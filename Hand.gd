extends Node

var hand = [null,null,null,null] # limit hand size to 4 
onready var deck = get_node("/root/Game/Deck")


func _ready():
	draw()
	for h in hand:
		print(h)
	print("-------------")
	
func draw():
	for e in hand.size():
		deck.give_one_card()
	
func play(a):
	for e in hand.size():
		if hand[e].get_shape_name() == a.get_shape_name():
			hand.delete(hand[e])
	
	discard_hand()
			
func discard_hand():
	hand.clear()
