#import "PJApplicationDelegate.h"

@implementation PJApplicationDelegate
@synthesize renderer, state, resolutionX, resolutionY, isFullscreen, eventHandler;
- (void)applicationDidFinishLaunching
{
	resolutionX = 800;
	resolutionY = 600;
	isFullscreen = false;

	cpInitChipmunk();

	eventHandler = [PJEventHandler eventHandler];

	renderer = [PJRenderer rendererForApplication: self];

	state = [defaultGameState new];

	[renderer renderLoop];

	[OFApplication terminate];
}
@end

OF_APPLICATION_DELEGATE(PJApplicationDelegate);