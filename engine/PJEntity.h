#import <ObjFW/ObjFW.h>
#import <SDL2/SDL_image.h>
#import "PJImage.h"

#define CP_USE_CGPOINTS 0
#import <chipmunk/chipmunk.h>
#import "PJGameState.h"

@class PJImage;

typedef enum { 
	PJRectangle = 0,
	PJCircle = 1,
	PJPolygon = 2
} PJShape;

@interface PJEntity : OFObject<OFComparing>
{
	int32_t x;
	int32_t y;
	int8_t z;
	uint32_t width;
	uint32_t height;
	uint16_t angle;
	int8_t frame;
	PJImage* image;
	PJShape shape;
	cpBody* body;
	bool isClickable;
	PJGameState* gameState;
}
@property (nonatomic) int32_t x;
@property (nonatomic) int32_t y;
@property int8_t z;
@property uint32_t width;
@property uint32_t height;
@property uint16_t angle;
@property int8_t frame;
@property bool isClickable;
@property PJShape shape;
@property cpBody* body;
@property (strong) PJGameState* gameState;
@property (strong) PJImage* image;
- (void)preRender;
- (void)postRender;
- (void)onMouseButtonDown;
- (void)onMouseButtonUp;
+ entityWithGameState: (PJGameState*)state;
- initWithGameState: (PJGameState*)state;
@end