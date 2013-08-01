#import <ObjFW/ObjFW.h>
#import <SDL2/SDL.h>
#import "PJApplicationDelegate.h"

@interface PJImage : OFObject
{
	uint8_t frames;
	SDL_Texture** textures;
}
@property uint8_t frames;
+ imageForName: (OFString*)imageName;
+ animationForName: (OFString*)imageName;
- initForImageName: (OFString*)imageName isAnimation: (bool)isAnimation;
- (SDL_Texture*)textureForFrame: (uint8_t)frameNumber;
@end