extends Node

const DIALOGUE_LINES : Dictionary = {
	"level1_guard": {"line": "Good to see Cronjager's still finding work, but those eyes of his aren't doing him any favours. As long as I'm in the dark, I'm invisible."},
	"level1_platform": {"line": "I hate to admit it, but I'm no jumper. I can drop down from here, but getting back up will be harder..."},
	"level1_box": {"line": "That box could make for a nice bit of cover. A little small, but you know the saying: if I fits..."},
	"level1_camera": {"line": "Using last year's security cameras, Harry? How embarrassing."},
	"level1_computer": {"line": "Oh, Harry... still young at heart, I see. But your selfie game needs work. I'll just take a copy of these; they'll make for good insurance."},
	"level1_goal": {"line": "That should be enough. I can see myself out... or I can stick around and really make this worth my while."},
	"level2_guard": {"line": "Aw, Cronjager... burning the midnight oil again? Someone hasn't had his coffee. I could make use of that."},
	"level2_statue": {"line": "Talk about still life..."},
	"level2_poster": {"line": "*sigh* I was really looking forward to that movie..."},
	"level2_vent1": {"line": "That vent looks large about to fit in. It's not graceful, but it's the best way of getting about completely undetected."},
	"level2_vent2": {"line": "Completely. Un. Detected."},
	"level2_computer": {"line": "Holding out on Uncle Sam, are we, Chandler? Cab drivers pay more tax than that."},
	"level2_goal": {"line": "Well, aren't you a pretty little thing. Lighter than I was expecting, too..."},
	"level3_vase": {"line": "Hope it was worth it, Chandler."}
}

func get_dialogue_line(which : String) -> String:
	return DIALOGUE_LINES[which]["line"]

func get_dialogue_vo_path(which : String) -> String:
	return "res://audio/vo/" + which + ".ogg"
