//
//  Bird.m
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "Bird.h"
CGSize ws;
@implementation Bird


@synthesize mc,aniArr,ani,ate,speed;


// on "init" you need to initialize your instance
-(id) init
{
	
	if( (self=[super init]) ) {
        ws=[[CCDirector sharedDirector]winSize];
        self.mc=[[CCSprite alloc]init];
        [self addChild:self.mc];
        
        self.aniArr=[[NSMutableArray alloc]init];
       
        for (int i=1; i<30; i++) {
         [self.aniArr addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:(i<10?[NSString stringWithFormat:@"birdFly000%i.png",i]:[NSString stringWithFormat:@"birdFly00%i.png",i])]];
        }
        self.ani=[CCAnimation animationWithSpriteFrames:self.aniArr delay:0.05];
        [self.mc runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:self.ani]]];
    }

    return self;
}

-(void)startMoveWithSpeed:(float)sp{
    self.speed=sp;
    [self schedule:@selector(loop)];
}

-(void)loop{
    self.position=ccp(self.position.x+self.speed,self.position.y);
    if (self.speed>0&&self.position.x>ws.width+self.contentSize.width+100) {
        self.speed*=-1;
        
    }
    if (self.speed<0&&self.position.x<-100) {
        self.speed*=-1;
    }
    self.scaleX=fabs(self.scaleX)*(self.speed>0?1:-1);
    
}

@end
