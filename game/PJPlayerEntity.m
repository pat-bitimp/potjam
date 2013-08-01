#import "PJPlayerEntity.h"

@implementation PJPlayerEntity
- initWithGameState: (PJGameState*)state
				  x: (int32_t)_x
				  y: (int32_t)_y
				  z: (uint8_t)_z
			  width: (uint32_t)_width
	         height: (uint32_t)_height
	       rotation: (uint16_t)_angle
{
	self = [super initWithGameState: state
				                  x: (int32_t)_x
				                  y: (int32_t)_y
				                  z: (uint8_t)_z
			                  width: (uint32_t)_width
	                         height: (uint32_t)_height
	                       rotation: (uint16_t)_angle];

	image = [PJImage imageForName: @"media/player"];

	frame = 0;
	isClickable = true;

	cpFloat radius = width/2;
	cpFloat mass = 1;

	// The moment of inertia is like mass for rotation
	// Use the cpMomentFor*() functions to help you approximate it.
	cpFloat moment = INFINITY; // cpMomentForCircle(mass, 0, radius, cpvzero);

	// The cpSpaceAdd*() functions return the thing that you are adding.
	// It's convenient to create and add an object in one line.
	cpBody *ballBody = cpSpaceAddBody(gameState.space, cpBodyNew(mass, moment));
	cpBodySetPos(ballBody, cpv(x, y));

	// Now we create the collision shape for the ball.
	// You can create multiple collision shapes that point to the same body.
	// They will all be attached to the body and move around to follow it.
	cpShape *ballShape = cpSpaceAddShape(gameState.space, cpCircleShapeNew(ballBody, radius, cpvzero));
	ballShape->u = 1.0f;

	body = ballBody;

	return self;
}

- (void)preRender
{
	PJApplicationDelegate* app = (PJApplicationDelegate*)[[OFApplication sharedApplication] delegate];

	PJPoint camera = {x - app.resolutionX / 2, y - app.resolutionY / 2};
	gameState.camera = camera;
}

- (void)postRender
{

}

- (void)onMouseButtonUp
{
	self.x = 10;
	self.y = 10;
	of_log(@"player clicked");
}
@end