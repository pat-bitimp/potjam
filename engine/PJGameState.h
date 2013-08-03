#import <ObjFW/ObjFW.h>
#import "PJEntity.h"
#import <Box2D/Box2D.h>

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
	b2World* physicWorld;
}
@property (readonly) OFSortedList* entities;
@property PJPoint camera;
@property int8_t backgroundColorR;
@property int8_t backgroundColorG;
@property int8_t backgroundColorB;
@property (strong)PJEntity* player;
@property b2World* physicWorld;
- (void)onMouseButtonDown;
- (void)onMouseButtonUp;
- (void)physicTickForTimeInterval: (double)time;
- (void)logicTickForTimeInterval: (double)time;
@end