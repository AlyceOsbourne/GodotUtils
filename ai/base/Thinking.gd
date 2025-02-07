class_name Thinking
extends State



func enter():
    print("Entered Thinking")

func physics_process(__):
    ai.think()
