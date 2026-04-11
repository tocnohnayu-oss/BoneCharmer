extends Node2D


@onready var menu_scene = preload("res://UI/Main_Menu/Main_Menu.tscn")
@onready var UI_Layer = $UI_Layer
@onready var player_scene = preload("res://Player/Player.tscn")
@onready var audio_player = $MusicPlayer
@onready var sound_effects_player = $SoundEffectsPlayer
@onready var soundtrack1 = preload("res://Assets/Soundtracks/BoneCharm_soundtrack.mp3")
@onready var soundtrack2 = preload("res://Assets/Soundtracks/BoneCharm_soundtrack2.mp3")
@onready var soundtrack3 = preload("res://Assets/Soundtracks/BoneCharm_soundtrack3.mp3")
var basic_volume
var soundtracks
var current_soundtrack_number = -1


func _ready() -> void:
	basic_volume = audio_player.volume_db
	var menu = menu_scene.instantiate()
	UI_Layer.add_child(menu)


func _process(delta: float) -> void:
	pass


func next_soundtrack():
	current_soundtrack_number = current_soundtrack_number + 1 if current_soundtrack_number + 1 < len(soundtracks) else 0
	audio_player.stream = soundtracks[current_soundtrack_number]
	audio_player.play()


func _on_audio_stream_player_finished() -> void:
	next_soundtrack()


func start_game():
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
