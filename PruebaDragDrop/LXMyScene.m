//
//  LXMyScene.m
//  PruebaDragDrop
//
//  Created by Oscar Devis on 20/01/14.
//  Copyright (c) 2014 lexcode. All rights reserved.
//

#import "LXMyScene.h"

@interface LXMyScene ()

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKSpriteNode *selectedNode;

@end

@implementation LXMyScene


- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Create spriteNode with a image for a background
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        [_background setName:@"background"];
        [_background setAnchorPoint:CGPointZero];
        _background.size = CGSizeMake(1136/2, 640/2);
        [_background setName:@"background"];

        [self addChild:_background];
        
        
        //Create spriteNode for spacheships
        NSArray *imageNames = @[@"Spaceship", @"Spaceship"];
        for(int i = 0; i < [imageNames count]; ++i) {
            NSString *imageName = [imageNames objectAtIndex:i];
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
            [sprite setSize:CGSizeMake(40, 40)];
            [sprite setName:imageName];
            
            float offsetFraction = ((float)(i + 1)) / ([imageNames count] + 1);
            [sprite setPosition:CGPointMake(size.width * offsetFraction, size.height / 2)];
            [_background addChild:sprite];
        }
    }
    
    return self;
}


- (void)selectNodeForTouch:(CGPoint)touchLocation {

    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
     _selectedNode = touchedNode;
    //If touchedNode is a spaceShip create a range
    if([touchedNode children].count==0)
        [self addRange:touchedNode];
    
}
- (void)addRange:(SKSpriteNode *)node
{
    //Create a spriteNode for the range
    SKSpriteNode *aura= [[SKSpriteNode alloc]initWithImageNamed:@"range"];
     aura.size= CGSizeMake(160,160);
    [node addChild:aura];
    
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


#pragma mark Drag&Drop
- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    //If spaceShip then move to new position
    if([_selectedNode.name isEqualToString:@"Spaceship"]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    }
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
}
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
        
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //If spaceShip remove range
        if([_selectedNode.name isEqualToString:@"Spaceship"]) {
        [_selectedNode removeAllChildren];
        }
    }
}



@end

