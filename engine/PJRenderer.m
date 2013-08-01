#import "PJRenderer.h"

//static const uint32_t fps = 40;
//static const uint32_t minframetime = 1000 / fps;

@implementation PJRenderer
@synthesize renderer, mouseX, mouseY;
+ rendererForApplication: (PJApplicationDelegate*)app
{
	PJRenderer* obj = [[self alloc] initWithApplication: app];

	return obj;
}

- initWithApplication: (PJApplicationDelegate*)app
{
	application = app;
	stop = false;

	SDL_Init(SDL_INIT_VIDEO);

	window = SDL_CreateWindow([[OFApplication programName] UTF8String], 
							  SDL_WINDOWPOS_CENTERED, 
							  SDL_WINDOWPOS_CENTERED, 
							  application.resolutionX, 
							  application.resolutionY, 
							  application.isFullscreen ? SDL_WINDOW_FULLSCREEN_DESKTOP : 0);

	renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

	SDL_ShowCursor(0);

	return [self init];
}

- (void)stop
{
	stop = true;
}

- (void)updateWindowTitle
{
	OFString* str = [OFString stringWithFormat: @"%@ %d", PJGameName, fps];
	SDL_SetWindowTitle(window, [str UTF8String]);
}

- (void)renderLoop
{
	OFString* oldError = [OFString string];
	OFDate* lastUpdate = [OFDate date];

	OFDate* secondStart = [OFDate date];

	int32_t frameCount;
	while(!stop)
	{
		OFDate* now = [OFDate date];

		SDL_SetRenderDrawColor(renderer, 
			application.state.backgroundColorR, 
		    application.state.backgroundColorG, 
		    application.state.backgroundColorB, 
		    255);
		
		SDL_RenderClear(renderer);

		OFSortedList* entities;

		@synchronized(application.state.entities)
		{
			entities = [application.state.entities copy];	
		}

		[application.state physicTickForTimeInterval: 0.01];
		[application.state logicTickForTimeInterval: 0.01];

		SDL_Event e;

		if (SDL_PollEvent(&e)) 
		{
			[application.eventHandler handleEvent: e];
		}

		for(PJEntity* entity in entities)
		{
			[entity preRender];
			[self renderEntity: entity];
			[entity postRender];
		}

		SDL_RenderPresent(renderer);

		OFString* newError = [OFString stringWithUTF8String: SDL_GetError()];

		if (![newError isEqual: oldError])
		{
			of_log((OFConstantString*)newError);
			oldError = newError;
		}

		lastUpdate = [OFDate date];
		frameCount++;

		if ([[OFDate date] timeIntervalSinceDate: secondStart] >= 1.0)
		{
			fps = frameCount;
			frameCount = 0;
			[self updateWindowTitle];
			secondStart = [OFDate date];
		}
	}

	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
}

- (void)renderEntity: (PJEntity*)entity
{
	SDL_Rect rect; 
	rect.x = entity.x - application.state.camera.x - (entity.width/2);
	rect.y = entity.y - application.state.camera.y - (entity.height/2); 
	rect.w = entity.width; 
	rect.h = entity.height; 

	SDL_Texture* texture = [entity.image textureForFrame: entity.frame];

	SDL_RenderCopyEx(renderer, texture, 
		NULL, &rect, entity.angle, NULL, SDL_FLIP_NONE);
}

- (PJEntity*)getEntityUnderCursorFromCollection: (OFSortedList*)list needsToBeClickable: (bool)clickable
{
	for (of_list_object_t* iter = [list lastListObject]; iter != NULL; iter = iter->previous)
	{
		PJEntity* entity = iter->object;

		PJPoint cursor;
		cursor.x = mouseX - 24 + application.state.camera.x;
		cursor.y = mouseY - 24 + application.state.camera.y;

		if (clickable && !entity.isClickable)
		{
			continue;
		}

		if (entity.shape == PJRectangle && [self point: cursor isInRectangle: entity])
		{
			return entity;
		}
	}

	return nil;
}

- (bool)point: (PJPoint)point isInRectangle: (PJEntity*)entity
{
	float rad = (-entity.angle) * M_PI/180;
	float c = cos(rad);
    float s = sin(rad);

    float x  = entity.x - application.state.camera.x;
    float y  = entity.y - application.state.camera.y;
    float w  = entity.width;
    float h  = entity.height;

    float rotX = (x + c * (point.x - x) - s * (point.y - y));
    float rotY = (y + s * (point.x - x) + c * (point.y - y));

    float lx = (x - w / 2.f);
    float rx = (x + w / 2.f);
    float ty = (y - h / 2.f);
    float by = (y + h / 2.f);

    return lx <= rotX && rotX <= rx && ty <= rotY && rotY <= by;
}
@end