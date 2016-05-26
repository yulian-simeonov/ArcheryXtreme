//
//  BowArrow.m
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "BowArrow.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
@implementation BowArrow
@synthesize bow,bowMovie,animObj,bowArr,arrow,shootAble;
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        self.shootAble=YES;
        
        
        
        self.bow=[ CCSprite spriteWithSpriteFrameName:@"BowAni0001.png" ];
        
        [self addChild:self.bow];
        
         
        
        self.animObj = [CCAnimation animation];
        for( int i=1;i<=18;i++){
          
            [self.animObj addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"BowAni%04d.png", i]]];
        }
        
        
        self.animObj.delayPerUnit = 0.03f;
        self.animObj.restoreOriginalFrame = YES;
        

        
        self.arrow=[CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        self.arrow.anchorPoint=ccp(0.76,0.5);
        self.arrow.position=ccp(30,0);
        [self addChild:self.arrow];
        

	}
	return self;
}
//play shoot movie
-(void)playShootMovie{
    
    
    if(self.shootAble){
      [self.bow stopAllActions];
        id cccf=[CCCallFunc actionWithTarget:self selector:@selector(delayRun)];
        id seq=[CCSequence actions:[CCAnimate actionWithAnimation:self.animObj],cccf, nil];
      [self.bow runAction:seq];
      [self.arrow setVisible:NO];
      self.shootAble=NO;
      [self unschedule:@selector(delayRun)];
      [self schedule:@selector(delayRun) interval:0.7];
       [[SimpleAudioEngine sharedEngine]playEffect:@"snd_move.wav"];
    }
}
//delay
-(void)delayRun{
    self.shootAble=YES;
    [self.arrow setVisible:YES];
}

@end
