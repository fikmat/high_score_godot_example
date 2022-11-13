extends Node

class_name Player

var nickname : String
var score : int

var naming_alphabet_index : int
var naming_position_index : int

var action : int
var direction_up : int
var direction_right : int
var direction_down : int
var direction_left : int

func _init():
  _setup_controls(KEY_ENTER, KEY_UP, KEY_RIGHT, KEY_DOWN, KEY_LEFT)

func reset() -> void:
  score = 0
  nickname = "AAAAAA"
  naming_alphabet_index = 0
  naming_position_index = 0

func _setup_controls(a: int, d_up: int, d_right: int, d_down: int, d_left: int) -> void:
  action = a
  direction_up = d_up
  direction_right = d_right
  direction_down = d_down
  direction_left = d_left
