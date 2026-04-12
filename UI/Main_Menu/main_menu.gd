extends Control


@onready var Main_Scene = get_tree().get_first_node_in_group("Main_Scene")
@onready var Start_Button = $Buttons/Start_Button
@onready var Settings_Button = $Buttons/Settings_Button
@onready var Quit_Button = $Buttons/Quit_Button
@onready var buttons = [Start_Button, Settings_Button, Quit_Button]
@onready var soundtrack = preload("res://Assets/UIAssets/Main_Menu/v002_alpha/Soundtrack/Soska_koza_main_menu_soundtrack.wav")
@onready var select_sound = preload("res://Assets/UIAssets/Main_Menu/v002_alpha/Sound_Effects/ui_select_sound.mp3")
@onready var enter_sound = preload("res://Assets/UIAssets/Main_Menu/v002_alpha/Sound_Effects/ui_enter_sound.mp3")
var active_button


func _ready() -> void:
	var audio_player = Main_Scene.audio_player
	audio_player.stream = soundtrack
	Main_Scene.soundtracks = [soundtrack]
	audio_player.volume_db = -20.0
	audio_player.play()
	active_button = Start_Button


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	var new_button_index = 0
	var active_button_index = buttons.find(active_button)
	if event.is_action_pressed("select_down"):
		audio_play_sound(select_sound, -20)
		new_button_index = active_button_index - 1 if active_button_index > 0 else 2
	elif event.is_action_pressed("select_up"):
		audio_play_sound(select_sound, -20)
		new_button_index = (active_button_index + 1) % 3
	elif event.is_action_pressed("accept"):
		audio_play_sound(enter_sound, -5)
		match active_button:
			Start_Button: start_game()
			Settings_Button: open_settings()
			Quit_Button: quit_game()
		return
	else:
		return
	change_active_button(buttons[new_button_index])


func set_visibility_to_triangles(button: TextureButton, state: bool):
	for triangle in button.get_children():
		triangle.visible = state


func change_active_button(new_active_button: TextureButton):
	active_button = new_active_button
	for button in buttons:
		set_visibility_to_triangles(button, button == new_active_button)


func start_game():
	Main_Scene.start_game()


func open_settings():
	pass
	

func quit_game():
	get_tree().quit()


func audio_play_sound(sound, volume):
	var audio_player = Main_Scene.sound_effects_player
	audio_player.stream = sound
	audio_player.volume_db = volume
	audio_player.play()
