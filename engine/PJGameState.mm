#import "PJGameState.h"

@implementation PJGameState
@synthesize entities, camera, backgroundColorR, backgroundColorG, backgroundColorB, player, physicWorld;
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
			continue;
		}

		b2Transform transform = entity.body->GetTransform();

		entity.angle = transform.q.GetAngle() * M_PI/180;
		entity.x = (int)(PJMPXRatio * transform.p.x);
		entity.y = (int)(PJMPXRatio * transform.p.y);
	}

	physicWorld->Step(time, 8, 3);
}

- (void)initPhysic
{
	// Define the gravity vector.
    b2Vec2 gravity(0.0f, -10.0f);

    // Construct a world object, which will hold and simulate the rigid bodies.
    physicWorld = new b2World(gravity);
    physicWorld->SetAllowSleeping(true);
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
	delete physicWorld;
}
@end