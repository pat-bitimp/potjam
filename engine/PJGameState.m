#import "PJGameState.h"

@implementation PJGameState
@synthesize entities, camera, backgroundColorR, backgroundColorG, backgroundColorB, space;
- init
{
	self = [super init];
	entities = [OFSortedList list];

	backgroundColorR = 255;
	backgroundColorG = 255;
	backgroundColorB = 0;
	timeStep = 1.0/60.0;

	[self initPhysic];

	/*[[OFThread threadWithThreadBlock: ^id() {
		

		while (true)
		{
			[self physicTick];
			[self logicTick];
			[OFThread sleepForTimeInterval: 0.1];
		} 
	}] start];*/

	return self;
}

- (void)physicTick
{
	OFSortedList* _entities;

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

	cpSpaceStep(space, timeStep);
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

- (void)logicTick
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