extends Node

func enojada():
	$Normal.visible = false
	$Indiferente.visible = true
	$Feliz.visible = false	  

func feliz():
	$Normal.visible = false
	$Indiferente.visible = false
	$Feliz.visible = true
	
func normal():
	$Normal.visible = true
	$Indiferente.visible = false
	$Feliz.visible = false	 
