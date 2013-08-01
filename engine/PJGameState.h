#import <ObjFW/ObjFW.h>
#define CP_USE_CGPOINTS 0
#import <chipmunk/chipmunk.h>
#import "PJEntity.h"

@class PJEntity;

typedef struct
{
	int32_t x;
	int32_t y;
} PJPoint;

@interface PJGameState : OFObject
{
	OFSortedList* entities;
	PJPoint camera;
	int8_t backgroundColorR;
	int8_t backgroundColorG;
	int8_t backgroundColorB;
	PJEntity* player;
	cpSpace* space;
	cpFloat timeStep;
}
@property (readonly) OFSortedList* entities;
@property PJPoint camera;
@property int8_t backgroundColorR;
@property int8_t backgroundColorG;
@property int8_t backgroundColorB;
@property (strong)PJEntity* player;
@property cpSpace* space; 
- (void)onMouseButtonDown;
- (void)onMouseButtonUp;
- (void)physicTickForTimeInterval: (double)time;
- (void)logicTickForTimeInterval: (double)time;
@end