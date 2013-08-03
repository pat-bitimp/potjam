#import <ObjFW/ObjFW.h>
#import <SDL2/SDL.h>
#import <SDL2/SDL_image.h>
#import "PJEntity.h"
#import "PJGameState.h"
#import "PJApplicationDelegate.h"
#import "PJImage.h"
#import "../config.h"
@class PJApplicationDelegate;
@class PJEntity;

@interface PJRenderer : OFObject
{
	SDL_Window* window;
	SDL_Renderer* renderer;
	PJApplicationDelegate* application;
	bool stop;
	int32_t mouseX;
	int32_t mouseY;
	int32_t absoluteMouseX;
	int32_t absoluteMouseY;
	uint32_t fps;
}
@property int32_t mouseX;
@property int32_t mouseY;
@property int32_t absoluteMouseX;
@property int32_t absoluteMouseY;
@property (readonly) OFThread* thread;
@property (readonly) SDL_Renderer* renderer;
+ rendererForApplication: (PJApplicationDelegate*)app;
- (void)renderLoop;
- (void)stop;
- (PJEntity*)getEntityUnderCursorFromCollection: (OFSortedList*)list needsToBeClickable: (bool)clickable;
@end