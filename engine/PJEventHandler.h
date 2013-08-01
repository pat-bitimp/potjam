#import <ObjFW/ObjFW.h>
#import <SDL2/SDL.h>
#import "PJApplicationDelegate.h"

@interface PJEventHandler : OFObject
{
	OFMutableDictionary* keyDownMapping;
	OFMutableDictionary* keyUpMapping;
}
+ eventHandler;
- (void)handleEvent: (SDL_Event)e;
- (void)registerKeyDownBlock: (void (^)(void))block forKeyCode: (int)keyCode;
- (void)registerKeyUpBlock: (void (^)(void))block forKeyCode: (int)keyCode;
@end