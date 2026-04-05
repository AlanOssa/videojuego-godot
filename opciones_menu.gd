extends Control

signal opcion_elegida(opcion)

@onready var btn_pregunta = $Panel/VBoxContainer/BtnPregunta
@onready var btn_terminal = $Panel/VBoxContainer/BtnTerminal
@onready var btn_explicar = $Panel/VBoxContainer/BtnExplicar

func _ready():
	btn_pregunta.text = " Quiero que me hagas una pregunta"
	btn_terminal.text = " Quiero probar la terminal"
	btn_explicar.text = " No entendí bien, explícame de nuevo"
	
	btn_pregunta.connect("pressed", _on_btn_pregunta)
	btn_terminal.connect("pressed", _on_btn_terminal)
	btn_explicar.connect("pressed", _on_btn_explicar)

func iniciar():
	visible = true

func _on_btn_pregunta():
	visible = false
	emit_signal("opcion_elegida", "pregunta")

func _on_btn_terminal():
	visible = false
	emit_signal("opcion_elegida", "terminal")

func _on_btn_explicar():
	visible = false
	emit_signal("opcion_elegida", "explicar")
