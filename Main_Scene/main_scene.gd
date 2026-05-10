extends Node2D


@onready var menu_scene = preload("res://UI/Main_Menu/Main_Menu.tscn")
@onready var UI_Layer = $UI_Layer
@onready var player_scene = preload("res://Player/Player.tscn")
@onready var audio_player = $MusicPlayer
@onready var sound_effects_player = $SoundEffectsPlayer
@onready var mobile_input = $MobileInput
@onready var soundtrack1 = preload("res://Assets/Soundtracks/BoneCharm_soundtrack.mp3")
@onready var soundtrack2 = preload("res://Assets/Soundtracks/BoneCharm_soundtrack2.mp3")
@onready var soundtrack3 = preload("res://Assets/Soundtracks/BoneCharm_soundtrack3.mp3")
var basic_volume
var soundtracks
var current_soundtrack_number = -1
var is_mobile_debug = false
var is_mobile 


func _ready() -> void:
	if not OS.is_debug_build():
		is_mobile_debug = false
	is_mobile = is_mobile_debug or OS.get_name() in ["Android", "IOS"]
	if not is_mobile:
		mobile_input.queue_free()
	else:
		mobile_input.visible = false
	basic_volume = audio_player.volume_db
	var menu = menu_scene.instantiate()
	UI_Layer.add_child(menu)


func _process(delta: float) -> void:
	if not is_mobile:
		return
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		return
	if $MobileInput/AttackJoystick._touch_index == -1:
		return
	player.current_state = player.State.ATTACK
	player.update_state()



func next_soundtrack():
	current_soundtrack_number = current_soundtrack_number + 1 if current_soundtrack_number + 1 < len(soundtracks) else 0
	audio_player.stream = soundtracks[current_soundtrack_number]
	audio_player.play()


func _on_audio_stream_player_finished() -> void:
	next_soundtrack()


func start_game():
	if mobile_input:
		mobile_input.visible = true
	audio_player.stop()
	audio_player.volume_db = basic_volume
	current_soundtrack_number = -1
	for child in UI_Layer.get_children():
		child.queue_free()
	soundtracks = [soundtrack1, soundtrack2, soundtrack3]
	next_soundtrack()
	Globals.change_current_map("res://Maps/Main_Map/Main_Map.tscn", Vector2(1152, 640))
	var player = player_scene.instantiate()
	self.add_child(player)
	player.position = Globals.player_position
