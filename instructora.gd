extends Control

var nombre_jugador = ""
var esperando_respuesta := false
var respuesta_correcta := "guardar informacion"   # <-- puedes cambiarlo
var pregunta_realizada := false

var dialogo = [
	["Ins. Marcela", "¡Hola! Bienvenido a la clase de Python.", "feliz"],
	["Ins. Marcela", "Antes de comenzar, necesito saber tu nombre.", "normal"],
	["Ins. Marcela", "Por favor, escribe cómo quieres ser llamado:", "indiferente"],
	["INPUT", "", "normal"],
	["Ins. Marcela", "Perfecto, {nombre}. Empecemos con algo básico.", "feliz"],
	["Ins. Marcela", "En Python, una *variable* es un espacio donde guardamos información.", "normal"],
	["Ins. Marcela", "Por ejemplo:\n[code]x = 10[/code] ", "normal"],
	
	# ── PUNTO DE ELECCIÓN ──────────────────────────────────
	["Ins. Marcela", "¿Cómo te gustaría continuar, {nombre}?", "feliz"],
	["OPCIONES", "", "normal"],  # ← abre el menú de opciones

	# ── RUTA 1: Solo pregunta ──────────────────────────────
	["RUTA_PREGUNTA", "", "normal"],
	["Ins. Marcela", "Bien, {nombre}. ¿Para qué sirve una variable en programación?", "indiferente"],
	["PREGUNTA", "", "normal"],
	["RESPUESTA_CORRECTA", "{nombre}, excelente. Espero mucho de ti.", "feliz"],
	["RESPUESTA_INCORRECTA", "No te preocupes, {nombre}. Tendrás más oportunidades.", "indiferente"],
	["FIN_RUTA", "", "normal"],

	# ── RUTA 2: Solo terminal ──────────────────────────────
	["RUTA_TERMINAL", "", "normal"],
	["Ins. Marcela", "¡Perfecto! Intenta escribir tu primera variable:", "feliz"],
	["CONSOLA", "x = 10", "normal"],
	["Ins. Marcela", "¡Excelente, {nombre}! Eso es exactamente una variable.", "feliz"],
	["FIN_RUTA", "", "normal"],

	# ── RUTA 3: Explicar de nuevo ──────────────────────────
	["RUTA_EXPLICAR", "", "normal"],
	["Ins. Marcela", "¡Claro que sí! Sin problema, {nombre}.", "feliz"],
	["Ins. Marcela", "Una variable es como una caja con una etiqueta.", "normal"],
	["Ins. Marcela", "Por ejemplo, si escribes:\n[code]edad = 20[/code]", "normal"],
	["Ins. Marcela", "Estás creando una caja llamada 'edad' que guarda el valor 20.", "normal"],
	["Ins. Marcela", "¿Ahora sí quedó más claro? ¿Cómo quieres continuar?", "feliz"],
	["OPCIONES", "", "normal"],  # ← vuelve a mostrar las opciones

	# ── DIÁLOGO FINAL COMÚN ────────────────────────────────
	["DIALOGO_FINAL", "", "normal"],
	["Ins. Marcela", "Gracias por participar. Esto es una DEMO v1.", "normal"],
]

var indice = 0
var velocidad = 0.03
var ruta_elegida = ""

@onready var consola = get_node("/root/Cap_1/ConsolaPython")
@onready var opciones_menu = get_node("/root/Cap_1/OpcionesMenu")


func _ready():
	consola.visible = false
	opciones_menu.visible = false
	opciones_menu.connect("opcion_elegida", _on_opcion_elegida)
	consola.connect("ejercicio_completado", _on_consola_completada)
	$"../Nombre/LineEditNombre".visible = false
	_mostrar_dialogo()


func _mostrar_dialogo():
	var nombre_label = $"../Nombre/Cnombre"
	var texto_label = $Saludo
	var sprite_node = $"../../Personajes/Instrutora"
	var entrada = dialogo[indice]
	var personaje = entrada[0]
	var texto = entrada[1]
	var expresion = entrada[2]
	# --- CASOS ESPECIALES ---
	if personaje == "INPUT":
		_mostrar_entrada_nombre()
		return
	
	if personaje == "OPCIONES":
		opciones_menu.iniciar()
		return
	
	# ── AGREGA ESTOS DOS ────────────────────────────
	if personaje == "FIN_RUTA":
		indice = _buscar_indice("DIALOGO_FINAL")
		indice += 1
		_mostrar_dialogo()
		return
		
	if personaje == "DIALOGO_FINAL":
		_siguiente_dialogo()
		return
	# ─────────────────────────────────────────────────
		
	if personaje == "PREGUNTA":
		_mostrar_pregunta()
		return
		
	if personaje == "CONSOLA":
		consola.iniciar(texto)
		return
		
	if personaje == "RESPUESTA_CORRECTA" and esperando_respuesta:
		texto = texto.replace("{nombre}", nombre_jugador)
		esperando_respuesta = false
	elif personaje == "RESPUESTA_INCORRECTA" and esperando_respuesta:
		texto = texto.replace("{nombre}", nombre_jugador)
		esperando_respuesta = false
	
	texto = texto.replace("{nombre}", nombre_jugador)
	nombre_label.text = personaje
	_aplicar_expresion(sprite_node, expresion)
	texto_label.bbcode_enabled = true
	texto_label.clear()
	texto_label.append_text(texto)
	texto_label.visible_characters = 0
	_mostrar_letra_por_letra(texto_label)

func _on_opcion_elegida(opcion: String):
	ruta_elegida = opcion
	match opcion:
		"pregunta":
			indice = _buscar_indice("RUTA_PREGUNTA")
			indice += 1  # Saltar el marcador directamente al contenido
		"terminal":
			indice = _buscar_indice("RUTA_TERMINAL")
			indice += 1
		"explicar":
			indice = _buscar_indice("RUTA_EXPLICAR")
			indice += 1
	_mostrar_dialogo()


func _mostrar_entrada_nombre():
	var label = $Saludo
	var line = $"../Nombre/LineEditNombre"
	var nombre_label = $"../Nombre/Cnombre"

	nombre_label.text = "Ins. Marcela"
	label.visible_characters = -1
	label.bbcode_text = "Escribe tu nombre abajo y presiona ENTER:"

	line.visible = true
	line.text = ""
	line.grab_focus()


func _mostrar_pregunta():
	var label = $Saludo
	var line = $"../Nombre/LineEditNombre"
	var nombre_label = $"../Nombre/Cnombre"

	nombre_label.text = "Ins. Marcela"
	label.bbcode_text = "Escribe tu respuesta y presiona ENTER."
	label.visible_characters = -1

	line.visible = true
	line.text = ""
	line.grab_focus()

	esperando_respuesta = true
	pregunta_realizada = true


func _aplicar_expresion(sprite_node, exp):
	for e in ["Normal", "Indiferente", "Feliz"]:
		sprite_node.get_node(e).visible = false

	match exp:
		"normal": sprite_node.get_node("Normal").visible = true
		"indiferente": sprite_node.get_node("Indiferente").visible = true
		"feliz": sprite_node.get_node("Feliz").visible = true


func _mostrar_letra_por_letra(label):
	for i in range(label.get_total_character_count()):
		label.visible_characters = i
		await get_tree().create_timer(velocidad).timeout


func _input(event):
	if event.is_action_pressed("ui_accept"):
		var entrada = dialogo[indice]

		if entrada[0] == "INPUT":
			_guardar_nombre()
			return

		if entrada[0] == "PREGUNTA":
			_procesar_respuesta()
			return

		_siguiente_dialogo()


func _guardar_nombre():
	var line = $"../Nombre/LineEditNombre"
	nombre_jugador = line.text.strip_edges()

	if nombre_jugador == "":
		return  # No avanzar si está vacío

	line.visible = false
	_siguiente_dialogo()


func _procesar_respuesta():
	var line = $"../Nombre/LineEditNombre"
	var respuesta = line.text.to_lower().strip_edges()

	line.visible = false

	# Normalizar respuesta
	var resp = respuesta.replace("para", "").replace("una", "").replace("la", "")
	resp = resp.replace("variable", "").strip_edges()

	var es_correcta = respuesta.find("guardar") != -1 or respuesta.find("informacion") != -1

	# Saltar al bloque correcto
	if es_correcta:
		indice = _buscar_indice("RESPUESTA_CORRECTA")
	else:
		indice = _buscar_indice("RESPUESTA_INCORRECTA")

	_mostrar_dialogo()


func _buscar_indice(tipo):
	for i in range(dialogo.size()):
		if dialogo[i][0] == tipo:
			return i
	return dialogo.size() - 1


func _siguiente_dialogo():
	indice += 1

	if indice >= dialogo.size():
		get_tree().quit()
		return

	var entrada = dialogo[indice]
	
	# Saltar marcadores de ruta
	if entrada[0] == "RUTA_PREGUNTA" or entrada[0] == "RUTA_TERMINAL" or entrada[0] == "RUTA_EXPLICAR":
		indice += 1
		if indice >= dialogo.size():
			get_tree().quit()
			return
		entrada = dialogo[indice]

	# Saltar RESPUESTA_CORRECTA e INCORRECTA si no estamos esperando respuesta
	if not esperando_respuesta:
		if entrada[0] == "RESPUESTA_CORRECTA" or entrada[0] == "RESPUESTA_INCORRECTA":
			indice += 1
			if indice >= dialogo.size():
				get_tree().quit()
				return

	_mostrar_dialogo() 

func _on_consola_completada():
	_siguiente_dialogo()
