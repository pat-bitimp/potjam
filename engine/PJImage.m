#import "PJImage.h"

@implementation PJImage
@synthesize frames;
+ imageForName: (OFString*)imageName
{
	return [[self alloc] initForImageName: imageName isAnimation: false];
}

+ animationForName: (OFString*)imageName
{
	return [[self alloc] initForImageName: imageName isAnimation: true];
}

- initForImageName: (OFString*)imageName isAnimation: (bool)isAnimation
{
	self = [super init];

	PJApplicationDelegate* app = (PJApplicationDelegate*)[[OFApplication sharedApplication] delegate];
	SDL_Renderer* renderer = app.renderer.renderer;

	if (!isAnimation)
	{
		frames = 1;
		textures = [self allocMemoryWithSize: sizeof(struct SDL_Texture*)];
		textures[0] = IMG_LoadTexture(renderer, [[self pathForImageName: imageName] UTF8String]);
	}
	else
	{
		for (int i = 0; i < 254; ++i)
		{
			OFString* imgPath = [self pathForImageName: [OFString stringWithFormat: @"%@_%@", imageName, i]];

			if (imgPath == nil)
				break;

			frames++;
		}

		textures = [self allocMemoryWithSize: sizeof(struct SDL_Texture*) count: frames];

		for (int i = 0; i < frames; ++i)
		{
			OFString* imgPath = [self pathForImageName: [OFString stringWithFormat: @"%@_%@", imageName, i]];
			textures[i] = IMG_LoadTexture(renderer, [imgPath UTF8String]);
		}
	}

	return self;
}

- (OFString*)pathForImageName: (OFString*)imageName
{
	OFString *extensions[4] = { @".png", @".gif", @".jpg", @".jpeg" };
	OFString *type = nil;

	for (uint_fast8_t i = 0; i < 4; i++)
	{
	    if ([OFFile fileExistsAtPath: [imageName stringByAppendingString: extensions[i]]])
	    {
	        type = extensions[i];
	        break;
	    }
	}

	return type == nil ? nil : [imageName stringByAppendingString: type];
}

- (SDL_Texture*)textureForFrame: (uint8_t)frameNumber
{
	if (frameNumber < frames)
	{
		return textures[frameNumber];
	}
	else
	{
		@throw [OFException new];
	}
}
@end