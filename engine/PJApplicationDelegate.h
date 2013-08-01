#import <ObjFW/ObjFW.h>
#import "PJRenderer.h"
#import "PJGameState.h"

Class defaultGameState;

@class PJRenderer;
@class PJGameState;

@interface PJApplicationDelegate : OFObject
{
	PJRenderer* renderer;
	PJGameState* state;
	int16_t resolutionX;
	int16_t resolutionY;
	bool isFullscreen;
}

@property (readonly, strong) PJRenderer* renderer;
@property int16_t resolutionY;
@property int16_t resolutionX;
@property bool isFullscreen;
@property PJGameState* state;
@end