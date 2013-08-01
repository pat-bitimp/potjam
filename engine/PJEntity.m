#import "PJEntity.h"

@implementation PJEntity
@synthesize x, y, z, width, height, angle, image, frame, isClickable, shape, body, gameState;
+ entityWithGameState: (PJGameState*)state
					x: (int32_t)_x
					y: (int32_t)_y
					z: (uint8_t)_z
				width: (uint32_t)_width
			   height: (uint32_t)_height
			 rotation: (uint16_t)_angle
{
	return [[self alloc] initWithGameState: state
					                     x: _x
					                     y: _y
					                     z: _z
				                     width: _width
			                        height: _height
			                      rotation: _angle];
}

- initWithGameState: (PJGameState*)state
			      x: (int32_t)_x
			      y: (int32_t)_y
			      z: (uint8_t)_z
		      width: (uint32_t)_width
	         height: (uint32_t)_height
		   rotation: (uint16_t)_angle
{
	self = [super init];

	x = _x;
	y = _y;
	z = _z;
	width = _width;
	height = _height;
	angle = _angle;
	gameState = state;
	frame = 0;

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
	if (_x == x)
		return;

	x = _x;

	if (body != NULL)
		cpBodySetPos(body, cpv(x, y));
}

- (void)setY: (int32_t)_y
{
	if (_y == y)
		return;

	y = _y;

	if (body != NULL)
		cpBodySetPos(body, cpv(x, y));
}

@end