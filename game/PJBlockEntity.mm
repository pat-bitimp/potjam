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

	// Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(PJPXMRatio * x, PJPXMRatio * y);

    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    body = state.physicWorld->CreateBody(&groundBodyDef);

    // Define the ground box shape.
    b2PolygonShape groundBox;

    // The extents are the half-widths of the box.
    groundBox.SetAsBox(PJPXMRatio * (width/2), PJPXMRatio * (height/2));

    of_log((OFConstantString*)[OFString stringWithFormat: @"boxX: %f boxY: %f", PJPXMRatio * x, PJPXMRatio * y]);

    // Add the ground fixture to the ground body.
    body->CreateFixture(&groundBox, 0.0f);

	return self;
}
@end