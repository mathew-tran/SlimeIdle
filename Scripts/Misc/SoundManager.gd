extends Node2D

var ClickSound = preload("res://Sounds/click.wav")
var ExitSound = preload("res://Sounds/click2.wav")
var RemoveSound = preload("res://Sounds/misc_menu.wav")
var AddSound = preload("res://Sounds/misc_menu_2.wav")

var lowerVolume = -10
var bIsMuted = false

var Music = [
	preload("res://Music/otherworldly_oceanside.wav"),
	preload("res://Music/stumble_around.wav"),
	preload("res://Music/sunnyday.wav")
]
func _ready():
	randomize()
	PlayMusic()
	
func PlayMusic():
	if bIsMuted == false:		
		$MusicChannel.stream = Music[rand_range(0, len(Music))]
		$MusicChannel.play()
		
func PlaySound(sfxPath, volume = 0, pitch = 1):
	
	if bIsMuted == false:
		var channel = $SoundChannels.get_child(0)
		for child in $SoundChannels.get_children():
			if child.playing == false:
				channel = child
				break
		channel.pitch_scale = pitch
		channel.volume_db = volume
		channel.stream = sfxPath
		channel.play()
	
func Click():
	PlaySound(ClickSound)
	
func Click2():
	PlaySound(ClickSound, lowerVolume, 2)

func Close():
	PlaySound(ExitSound)

func Add():
	PlaySound(AddSound, lowerVolume, 2)

func Remove():
	PlaySound(RemoveSound)

func ToggleMute():
	bIsMuted = !bIsMuted


func _on_Button_button_down():
	ToggleMute()
	if bIsMuted:
		$Button.text = "SOUND OFF"
		$MusicTimer.stop()
		$MusicChannel.stop()
	else:
		$Button.text = "SOUND ON"
		$MusicTimer.stop()
		PlayMusic()

	pass # Replace with function body.


func _on_MusicTimer_timeout():
	PlayMusic()
	pass # Replace with function body.


func _on_MusicChannel_finished():
	$MusicTimer.start()
	pass # Replace with function body.
