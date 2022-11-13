extends Screen

const HIGHSCORE_PATH = "res://data/highscore.json"
const BLINK_TIME = 0.4

export(int) var scores_count = 19

var current_scores := []
var rows := []
var blink := false
var blink_timer := Timer.new()

func _ready():
  if Global.scores.empty():
    Global.scores = parse_json_file(HIGHSCORE_PATH).scores

  _update_scores(Global.player)
  _set_timers()

  # add scores to the screen
  for i in scores_count:
    if i >= Global.scores.size():
      break

    var row : Control
    if i == 0:
      # override the first row
      row = $Row
    else:
      # and then add duplicates
      row = $Row.duplicate()
      row.rect_position.y += 42 * i
      add_child(row)

    row.get_node("Position").text = "%02d." % (i + 1)
    row.get_node("Name").text = Global.scores[i].name
    row.get_node("Score").text = _format_score(Global.scores[i].score)
    rows.append(row)

  if Global.scores.size() > 100:
    Global.scores.resize(100)

  write_json_file(HIGHSCORE_PATH, { "scores": Global.scores })

func sort_scores(a, b):
  if a.score < b.score:
    return true
  return false

func _format_score(score: int) -> String:
  var result := ""
  var i : int = abs(score)

  while i > 999:
    result = " %03d%s" % [i % 1000, result]
    i /= 1000

  return "%s%s%s" % ["-" if score < 0 else "", i, result]

func _update_scores(player: Player) -> void:
  if player.nickname.empty():
    return

  var new_score := { "name": player.nickname, "score": player.score }
  var success := false

  for i in Global.scores.size():
    if new_score.score > Global.scores[i].score:
      Global.scores.insert(i, new_score)
      success = true
      current_scores.append(i)
      break

  if !success:
    current_scores.append(Global.scores.size())
    Global.scores.append(new_score)

func _set_timers() -> void:
  blink_timer.connect("timeout", self, "_switch_blink")
  blink_timer.wait_time = BLINK_TIME
  add_child(blink_timer)
  blink_timer.start()

func _switch_blink() -> void:
  for s in current_scores:
    if s < rows.size():
      rows[s].visible = blink

  $Prompt.visible = blink

  blink = !blink

func _unhandled_input(event):
  if !active:
    return

  if event is InputEventKey:
    if event.pressed && !event.echo:
      go_to_next_screen()
