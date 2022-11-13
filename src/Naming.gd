extends Screen

const ALPHABET = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

var blink := false

func _ready():
  _set_blink_timer(0.4)
  Global.player.reset()

  # generate random score for us to save
  var rng := RandomNumberGenerator.new()
  rng.randomize()
  Global.player.score = rng.randi_range(99, 99999)
  $Score.text = "SCORE: " + String(Global.player.score)

func _process(_delta):
  _update_name_text($Name, Global.player)

func _update_name_text(label: RichTextLabel, player: Player) -> void:
  label.bbcode_text = player.nickname

  if blink:
    var format_string := "[color=#00ffffff]%s[/color]"
    var letter := label.bbcode_text[player.naming_position_index]
    label.bbcode_text[player.naming_position_index] = format_string % letter

func _unhandled_input(event):
  if event is InputEventKey:
    if event.pressed && !event.echo:
      _handle_player_inputs(event.scancode, Global.player)

func _handle_player_inputs(key_code: int, player: Player) -> void:
  match key_code:
    player.direction_up:
      if player.naming_alphabet_index < ALPHABET.size() - 1:
        player.naming_alphabet_index += 1
      else:
        player.naming_alphabet_index = 0
    player.direction_down:
      if player.naming_alphabet_index > 0:
        player.naming_alphabet_index -= 1
      else:
        player.naming_alphabet_index = ALPHABET.size() - 1
    player.direction_right:
      if player.naming_position_index < player.nickname.length() - 1:
        player.naming_position_index += 1
      else:
        player.naming_position_index = 0
      _update_position(player)
    player.direction_left:
      if player.naming_position_index > 0:
        player.naming_position_index -= 1
      else:
        player.naming_position_index = player.nickname.length() - 1
      _update_position(player)
    player.action:
      go_to_next_screen()

  player.nickname[player.naming_position_index] = ALPHABET[player.naming_alphabet_index]

func _update_position(player):
  if player.naming_position_index == player.nickname.length():
    player.nickname += ALPHABET[player.naming_alphabet_index]
    player.naming_alphabet_index = 0
  else:
    player.naming_alphabet_index = ALPHABET.find(player.nickname[player.naming_position_index])

func _set_blink_timer(wait_time: float) -> void:
  var timer := Timer.new()
  timer.connect("timeout", self, "_switch_blink")
  timer.wait_time = wait_time
  add_child(timer)
  timer.start()

func _switch_blink() -> void:
  blink = !blink
