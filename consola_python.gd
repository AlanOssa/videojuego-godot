extends Control

signal ejercicio_completado

var variables_jugador = {}
var codigo_esperado = ""

@onready var output = $Panel/VBoxContainer/Output
@onready var input_linea = $Panel/VBoxContainer/HBoxContainer/InputLinea
@onready var btn_cerrar = $BtnCerrar

func _ready():
	btn_cerrar.visible = false
	input_linea.connect("text_submitted", _on_input_submitted)
	$Panel/VBoxContainer/HBoxContainer/BtnEjecutar.connect("pressed", _on_btn_ejecutar)
	btn_cerrar.connect("pressed", _on_btn_cerrar)

# ── Llamado desde el diálogo principal ──────────────────────
func iniciar(esperado: String):
	variables_jugador.clear()
	output.clear()
	codigo_esperado = esperado
	input_linea.text = ""
	input_linea.editable = true
	btn_cerrar.visible = false
	input_linea.grab_focus()
	_imprimir("🐍 Consola Python Interactiva", "cyan")
	_imprimir("Escribe tu código y presiona ENTER\n", "gray")
	visible = true

# ── Imprimir en pantalla ─────────────────────────────────────
func _imprimir(texto: String, color: String = "white"):
	output.append_text("[color=%s]%s[/color]\n" % [color, texto])

# ── Ejecutar código ingresado ────────────────────────────────
func ejecutar_codigo(codigo: String):
	_imprimir(">>> " + codigo, "cyan")

	# Asignación: x = 10
	var regex_asign = RegEx.new()
	regex_asign.compile("^(\\w+)\\s*=\\s*(.+)$")
	var result = regex_asign.search(codigo)

	if result:
		var nombre_var = result.get_string(1)
		var valor = result.get_string(2).strip_edges()
		variables_jugador[nombre_var] = valor
		_imprimir("  ✅ Variable guardada: " + nombre_var + " = " + valor, "green")
		_verificar_solucion(codigo)
		return

	# print(x) o print("hola")
	if codigo.begins_with("print(") and codigo.ends_with(")"):
		var contenido = codigo.substr(6, codigo.length() - 7).strip_edges()
		if variables_jugador.has(contenido):
			_imprimir("  " + variables_jugador[contenido], "green")
		else:
			contenido = contenido.replace('"', '').replace("'", "")
			_imprimir("  " + contenido, "green")
		_verificar_solucion(codigo)
		return

	_imprimir("  ⚠️ Error: comando no reconocido", "red")
	_imprimir("  💡 Tip: prueba algo como   x = 10   o   print(x)", "yellow")

# ── Verificar solución ───────────────────────────────────────
func _verificar_solucion(codigo: String):
	var limpio = codigo.replace(" ", "").to_lower()
	var esperado_limpio = codigo_esperado.replace(" ", "").to_lower()

	if limpio == esperado_limpio:
		_imprimir("\n  🎉 ¡Correcto! Presiona Cerrar para continuar.", "green")
		btn_cerrar.visible = true
		input_linea.editable = false

# ── Señales UI ───────────────────────────────────────────────
func _on_input_submitted(text: String):
	if text.strip_edges() == "":
		return
	ejecutar_codigo(text.strip_edges())
	input_linea.text = ""

func _on_btn_ejecutar():
	_on_input_submitted(input_linea.text)

func _on_btn_cerrar():
	visible = false
	emit_signal("ejercicio_completado")
