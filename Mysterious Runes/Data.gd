extends Node

const PATH = "user://data.dat"

var is_loaded = false

var data = {
	"LevelsUnlock" : 1
}

func _ready():
	var file = File.new()
	
	if file.file_exists(PATH):
		load_data()
	else:
		save_data()
		load_data()

func update_data():
	data = {
		"LevelsUnlock" : Global.levelsUnlock
	}

func save_data():
	var file = File.new()
	
	file.open(PATH, File.WRITE)
	update_data()
	file.store_line(to_json(data))
	file.close()
	
	is_loaded = false

func load_data():
	if is_loaded:
		return
	
	var file = File.new()
	
	file.open(PATH, File.READ)
	data = parse_json(file.get_line())
	Global.levelsUnlock = data["LevelsUnlock"]
	file.close()
	
	is_loaded = true