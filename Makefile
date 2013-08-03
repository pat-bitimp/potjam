all:
	@objfw-compile --arc -o potjam engine/*.mm game/*.mm  -lSDL2 -lSDL2_image -lBox2D
