#import "PJCursorEntity.h"

@implementation PJCursorEntity
- init
{
	self = [super init];

	image = [PJImage imageForName: @"media/cursor"];
	width = 48;
	height = 48;
	x = 0;
	y = 0;
	z = 255;
	frame = 0;

	return self;
}

- (void)preRender
{
	PJApplicationDelegate* app = (PJApplicationDelegate*)[[OFApplication sharedApplication] delegate];
	x = app.renderer.mouseX + app.state.camera.x*2 - 24;
	y = app.renderer.mouseY + app.state.camera.y*2 - 24;

	//of_log((OFConstantString*)[OFString stringWithFormat: @"x: %d y: %d", x, y]);
}
@end