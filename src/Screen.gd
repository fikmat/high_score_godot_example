extends Control

class_name Screen

export(String) var next_screen_path

var active := true

func go_to_next_screen() -> void:
  # warning-ignore:return_value_discarded
  get_tree().change_scene(next_screen_path)

func parse_json_file(path: String) -> Dictionary:
    var file = File.new()
    var data : Dictionary

    if file.file_exists(path):
      file.open(path, File.READ)
      data = parse_json(file.get_as_text())
    else:
      data = {}

    file.close()

    return data

func write_json_file(path : String, data : Dictionary):
  var file = File.new()
  file.open(path, File.WRITE)
  file.store_line(to_json(data))
  file.close()

func _unhandled_input(event):
  if event is InputEventKey:
    if event.pressed:
      match event.scancode:
        KEY_N:
          go_to_next_screen()
