#import "PJPlayerEntity.h"

@implementation PJPlayerEntity
- initWithGameState: (PJGameState*)state
{
	self = [super initWithGameState: state];

	image = [PJImage imageForName: @"media/player"];
	width = 64;
	height = 64;
	x = 100;
	y = 100;
	frame = 0;
	isClickable = true;
	angle = 45;


	cpFloat radius = width/2;
	cpFloat mass = 1;

	// The moment of inertia is like mass for rotation
	// Use the cpMomentFor*() functions to help you approximate it.
	cpFloat moment = cpMomentForCircle(mass, 0, radius, cpvzero);

	// The cpSpaceAdd*() functions return the thing that you are adding.
	// It's convenient to create and add an object in one line.
	cpBody *ballBody = cpSpaceAddBody(gameState.space, cpBodyNew(mass, moment));
	cpBodySetPos(ballBody, cpv(x, y));

	// Now we create the collision shape for the ball.
	// You can create multiple collision shapes that point to the same body.
	// They will all be attached to the body and move around to follow it.
	cpShape *ballShape = cpSpaceAddShape(gameState.space, cpCircleShapeNew(ballBody, radius, cpvzero));
	cpShapeSetFriction(ballShape, 0.7);

	body = ballBody;

	return self;
}

- (void)preRender
{
	//of_log(@"prerender");
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