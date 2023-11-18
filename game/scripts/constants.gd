extends Node

const LEVEL_DETAILS : Array = [
	{
		"name": "Level 1",
		"briefing": "Looks like Sternwood isn't home. Probably told his wife he was going to spend the night reading, then slipped away to meet a nice young friend. Not that I'm complaining; with any luck, he'll have forgotten to set the alarm.",
		"objectives": "• Steal at least $500 worth of loot.\n• (Optional) Hack into Sternwood's computer.",
		"vo": "res://audio/vo/level1_briefing.ogg"
	},
	{
		"name": "Level 2",
		"briefing": "An old contact got back in touch with me this morning; said he knew of some work that could suit me. Lois Chandler recently brought home a certain vase. Worth millions... if you've got millions to spend on a vase. My cut won't be that much, but more than enough to get me out of this hole. Good thing my bag is well padded.",
		"objectives": "• Steal at least $500 worth of loot.\n• (Optional) Hack into Chandler's computer.",
		"vo": "res://audio/vo/level2_briefing.ogg"
	},
	{
		"name": "Level 3",
		"briefing": "It's a fake. They hired me to steal a fake. The real vase is still out there, and every paper in the city is talking about it. They played me like a fool; used me to advertise their precious little bit of stoneware and then cut me loose. I'd be an idiot to go after the real thing.\n\nWell, I guess that makes me an idiot. But I'm not just after that vase now. I'm going to dig up every last dark secret they've got. By the time I'm done, I'll have enough dirt to bury them the moment they come knocking on my door.",
		"objectives": "• Find the real vase.\n• Hack into one computer.\n• (Optional) Hack into all three computers..",
		"vo": "res://audio/vo/level3_briefing.ogg"
	},
]

func get_level_name(which : int) -> String:
	return LEVEL_DETAILS[which]["name"]

func get_level_briefing(which : int) -> String:
	return LEVEL_DETAILS[which]["briefing"]

func get_level_objectives(which : int) -> String:
	return LEVEL_DETAILS[which]["objectives"]

func get_level_vo_path(which : int) -> String:
	return LEVEL_DETAILS[which]["vo"]
