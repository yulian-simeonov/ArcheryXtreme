//
//  Arrow.m
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "Arrow.h"
#import "TargetObject.h"
#import "cocos2d.h"
@implementation Arrow
@synthesize mc;

-(id) init
{
	if( (self=[super init]) ) {
        self.mc=[CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        [self addChild:mc];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

@end
