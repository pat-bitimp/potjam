#import "PJBlockEntity.h"

@implementation PJBlockEntity
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

	image = [PJImage imageForName: @"media/block"];

	// TODO Shape Generation abstrahieren

	cpShape *block = cpSegmentShapeNew(gameState.space->staticBody, cpv(x-width/2, y+19+7), cpv((x-width/2)+width, y+19+7), 14);
  	block->u = 0.1f;
  	block->e = 0.7f;

  	cpSpaceAddShape(gameState.space, block);

	return self;
}
@end