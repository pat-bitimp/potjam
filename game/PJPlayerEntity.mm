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

	// Define the dynamic body. We set its position and call the body factory.
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(PJPXMRatio * x, PJPXMRatio * y);
    body = state.physicWorld->CreateBody(&bodyDef);

    of_log((OFConstantString*)[OFString stringWithFormat: @"playerX: %f playerY: %f", PJPXMRatio * x, PJPXMRatio * y]);

    // Define another box shape for our dynamic body.
    b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = PJPXMRatio * (_width/2);

    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicCircle;

    // Set the box density to be non-zero, so it will be dynamic.
    fixtureDef.density = 1.0f;

    // Override the default friction.
    fixtureDef.friction = 0.3f;

    // Add the shape to the body.
    body->CreateFixture(&fixtureDef);

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