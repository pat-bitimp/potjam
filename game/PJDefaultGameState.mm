#import "PJDefaultGameState.h"

@implementation PJDefaultGameState
- init
{
	self = [super init];

	PJApplicationDelegate* application = 
		(PJApplicationDelegate*)[[OFApplication sharedApplication] delegate];

	[application.eventHandler registerKeyDownBlock: ^{ 
		//cpBodyApplyImpulse(application.state.player.body, cpv(-100,0), cpv(0,0)); 
	} 
	                                    forKeyCode: SDLK_a];

	[application.eventHandler registerKeyDownBlock: ^{
		//cpBodyApplyImpulse(application.state.player.body, cpv(100,0), cpv(0,0));
	} 
	                                    forKeyCode: SDLK_d];

	backgroundColorR = 245;
	backgroundColorG = 184;
	backgroundColorB = 0;

	PJCursorEntity* cursor = [PJCursorEntity new];
	[entities insertObject: cursor];

	PJPlayerEntity* _player = 
		[PJPlayerEntity entityWithGameState: self
				                          x: 100
				                          y: 100
				                          z: 50
			                          width: 48
	                                 height: 48
	                               rotation: 0];
	[entities insertObject: _player];

	player = _player;

	PJBlockEntity* block = 
		[PJBlockEntity entityWithGameState: self
				                          x: 200
				                          y: 400
				                          z: 50
			                          width: 256
	                                 height: 32
	                               rotation: 0];
	[entities insertObject: block];

	PJBlockEntity* block2 = 
		[PJBlockEntity entityWithGameState: self
				                          x: 300
				                          y: 600
				                          z: 50
			                          width: 256
	                                 height: 32
	                               rotation: 0];
	[entities insertObject: block2];

	return self;
}

- (void)logicTickForTimeInterval: (double)time
{
}
@end