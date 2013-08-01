#import "PJDefaultGameState.h"

@implementation PJDefaultGameState
- init
{
	self = [super init];

	backgroundColorR = 0;
	backgroundColorG = 0;
	backgroundColorB = 0;

	PJCursorEntity* cursor = [PJCursorEntity new];
	[entities insertObject: cursor];

	PJPlayerEntity* player = [PJPlayerEntity entityWithGameState: self];
	[entities insertObject: player];

	return self;
}

+ (void)load
{
	defaultGameState = [self class];
}

- (void)logicTick
{
	//of_log(@"logic step");
}
@end