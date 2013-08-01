#import "PJEntity.h"

@implementation PJEntity
@synthesize x, y, z, width, height, angle, image, frame, isClickable, shape, body, gameState;
+ entityWithGameState: (PJGameState*)state
{
	return [[self alloc] initWithGameState: state];
}

- initWithGameState: (PJGameState*)state
{
	self = [super init];

	gameState = state;

	return self;
}

- (of_comparison_result_t)compare: (PJEntity*)object
{
	if (object.z > z)
	{
		return OF_ORDERED_DESCENDING;
	}
	else if (object.z < z)
	{
		return OF_ORDERED_ASCENDING;
	}

	return OF_ORDERED_SAME;
}

- (void)preRender
{
}

- (void)postRender
{
}

- (void)onMouseButtonDown
{
}

- (void)onMouseButtonUp
{
}

- (OFString*)description
{
	return [OFString stringWithFormat: @"x: %d y: %d", x, y];
}

- (void)setX: (int32_t)_x
{
	x = _x;

	if (body != NULL)
		cpBodySetPos(body, cpv(x, y));
}

- (void)setY: (int32_t)_y
{
	y = _y;

	if (body != NULL)
		cpBodySetPos(body, cpv(x, y));
}

@end