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

- (void)renderLoop
{
	OFString* oldError = [OFString string];
	//uint32_t frametime;

	while(!stop)
	{
		//frametime = SDL_GetTicks();

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

		[application.state physicTick];
		[application.state logicTick];

		SDL_Event e;

		if (SDL_PollEvent(&e)) 
		{
			if (e.type == SDL_QUIT)
				break;
			else if (e.type == SDL_MOUSEMOTION)
			{
				mouseX = e.motion.x - application.state.camera.x;
				mouseY = e.motion.y - application.state.camera.y;
			}
			else if (e.type == SDL_MOUSEBUTTONDOWN)
			{
				mouseX = e.motion.x - application.state.camera.x;
				mouseY = e.motion.y - application.state.camera.y;

				PJEntity* ent = [self getEntityUnderCursorFromCollection: entities needsToBeClickable: true];

				if (ent != nil)
					[ent onMouseButtonDown];
				else
					[application.state onMouseButtonDown];

				of_log((OFConstantString*)[OFString stringWithFormat: @"buttondown x: %d y: %d", mouseX, mouseY]);
			}
			else if (e.type == SDL_MOUSEBUTTONUP)
			{
				mouseX = e.motion.x - application.state.camera.x;
				mouseY = e.motion.y - application.state.camera.y;

				PJEntity* ent = [self getEntityUnderCursorFromCollection: entities needsToBeClickable: true];

				if (ent != nil)
					[ent onMouseButtonUp];
				else
					[application.state onMouseButtonUp];

				of_log((OFConstantString*)[OFString stringWithFormat: @"buttonup x: %d y: %d", mouseX, mouseY]);
			}
			else if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_LEFT)
			{
				PJPoint newCamera = {application.state.camera.x - 10, application.state.camera.y};
				mouseX += 10;
				application.state.camera = newCamera;
			}
			else if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_RIGHT)
			{
				PJPoint newCamera = {application.state.camera.x + 10, application.state.camera.y};
				mouseX -= 10;
				application.state.camera = newCamera;
			}
			else if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_UP)
			{
				PJPoint newCamera = {application.state.camera.x, application.state.camera.y - 10};
				mouseY += 10;
				application.state.camera = newCamera;
			}
			else if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_DOWN)
			{
				PJPoint newCamera = {application.state.camera.x, application.state.camera.y + 10};
				mouseY -= 10;
				application.state.camera = newCamera;
			}
			else if (e.type == SDL_KEYUP &&  e.key.keysym.sym == SDLK_ESCAPE)
				break;
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

		//if (SDL_GetTicks () - frametime < minframetime)
      	//	SDL_Delay(minframetime - (SDL_GetTicks () - frametime));
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