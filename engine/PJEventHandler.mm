#import "PJEventHandler.h"

@implementation PJEventHandler
+ eventHandler
{
	PJEventHandler* eventHandler = [[self alloc] init];
	return eventHandler;
}

- init
{
	self = [super init];

	keyUpMapping = [OFMutableDictionary dictionary];
	keyDownMapping = [OFMutableDictionary dictionary];

	return self;
}

- (void)handleEvent: (SDL_Event)e
{
	PJApplicationDelegate* application = 
		(PJApplicationDelegate*)[[OFApplication sharedApplication] delegate];

	OFSortedList* entities;

	@synchronized(application.state.entities)
	{
		entities = [application.state.entities copy];	
	}

	if (e.type == SDL_QUIT)
				[application.renderer stop];
	else if (e.type == SDL_MOUSEMOTION)
	{
		application.renderer.absoluteMouseX = e.motion.x;
		application.renderer.absoluteMouseY = e.motion.y;
		
	}
	else if (e.type == SDL_MOUSEBUTTONDOWN)
	{
		application.renderer.absoluteMouseX = e.motion.x;
		application.renderer.absoluteMouseY = e.motion.y;

		PJEntity* ent = [application.renderer getEntityUnderCursorFromCollection: entities needsToBeClickable: true];

		if (ent != nil)
			[ent onMouseButtonDown];
		else
			[application.state onMouseButtonDown];
	}
	else if (e.type == SDL_MOUSEBUTTONUP)
	{
		application.renderer.absoluteMouseX = e.motion.x;
		application.renderer.absoluteMouseY = e.motion.y;

		PJEntity* ent = [application.renderer getEntityUnderCursorFromCollection: entities needsToBeClickable: true];

		if (ent != nil)
			[ent onMouseButtonUp];
		else
			[application.state onMouseButtonUp];
	}
	else if (e.type == SDL_KEYDOWN)
	{
		OFNumber* key = [OFNumber numberWithInt: e.key.keysym.sym];
		void (^block)(void);

		if ((block = [keyDownMapping objectForKey: key]) != nil)
		{
			block();
		}
	}
	else if (e.type == SDL_KEYUP)
	{
		OFNumber* key = [OFNumber numberWithInt: e.key.keysym.sym];
		void (^block)(void);

		if ((block = [keyUpMapping objectForKey: key]) != nil)
		{
			block();
		}
	}
}

- (void)registerKeyDownBlock: (void (^)(void))block forKeyCode: (int)keyCode
{
	keyDownMapping[@(keyCode)] = block;
}

- (void)registerKeyUpBlock: (void (^)(void))block forKeyCode: (int)keyCode
{
	keyUpMapping[@(keyCode)] = block;
}

@end