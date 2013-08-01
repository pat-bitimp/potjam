#import <ObjFW/ObjFW.h>
#import <SDL2/SDL.h>
#import <SDL2/SDL_image.h>
#import "PJEntity.h"
#import "PJGameState.h"
#import "PJApplicationDelegate.h"
#import "PJImage.h"
@class PJApplicationDelegate;

@interface PJRenderer : OFObject
{
	SDL_Window* window;
	SDL_Renderer* renderer;
	PJApplicationDelegate* application;
	bool stop;
	uint16_t mouseX;
	uint16_t mouseY;
}
@property uint16_t mouseX;
@property uint16_t mouseY;
@property (readonly) OFThread* thread;
@property (readonly) SDL_Renderer* renderer;
+ rendererForApplication: (PJApplicationDelegate*)app;
- (void)renderLoop;
- (void)stop;
@end