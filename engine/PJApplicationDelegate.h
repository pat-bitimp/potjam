#import <ObjFW/ObjFW.h>
#import "PJRenderer.h"
#import "PJGameState.h"
#import "PJEventHandler.h"
#define CP_USE_CGPOINTS 0
#import <chipmunk/chipmunk.h>

Class defaultGameState;

@class PJRenderer;
@class PJGameState;
@class PJEventHandler;

@interface PJApplicationDelegate : OFObject
{
	PJRenderer* renderer;
	PJGameState* state;
	PJEventHandler* eventHandler;
	int16_t resolutionX;
	int16_t resolutionY;
	bool isFullscreen;
}

@property (readonly, strong) PJRenderer* renderer;
@property (strong) PJEventHandler* eventHandler;
@property int16_t resolutionY;
@property int16_t resolutionX;
@property bool isFullscreen;
@property (strong)PJGameState* state;
@end