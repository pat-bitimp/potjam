#import "PJGameState.h"

@implementation PJGameState
@synthesize entities, camera, backgroundColorR, backgroundColorG, backgroundColorB, space, player;
- init
{
	self = [super init];
	entities = [OFSortedList list];

	backgroundColorR = 255;
	backgroundColorG = 255;
	backgroundColorB = 0;
	[self initPhysic];

	return self;
}

- (void)physicTickForTimeInterval: (double)time
{
	OFSortedList* _entities;

	//of_log((OFConstantString*)[OFString stringWithFormat: @"%f", time]);

	@synchronized(entities)
	{
		_entities = [entities copy];	
	}

	for (PJEntity* entity in _entities)
	{
		if (entity.body == NULL)
		{
			//of_log(@"null physic body entity: %@!", entity.description);
			continue;
		}

		cpVect pos = cpBodyGetPos(entity.body);

		//of_log((OFConstantString*)[OFString stringWithFormat: @"nx: %f ny: %f ox: %d oy: %d"], pos.x, pos.y, entity.x, entity.y);

		entity.x = (int)pos.x; //pos.x;
		entity.y = (int)pos.y; //pos.y;
	}

	cpSpaceStep(space, time);
}

- (void)initPhysic
{
	cpVect gravity = cpv(0, 10);

	// Create an empty space.
	space = cpSpaceNew();
	cpSpaceSetGravity(space, gravity);
}

- (void)onMouseButtonDown
{
}

- (void)onMouseButtonUp
{
}

- (void)logicTickForTimeInterval: (double)time
{
	//of_log(@"no logic implemented");
}

- (void)dealloc
{
	// Clean up our objects and exit!
	// cpShapeFree(ballShape);
	// cpBodyFree(ballBody);
	// cpSpaceFree(space);
}
@end