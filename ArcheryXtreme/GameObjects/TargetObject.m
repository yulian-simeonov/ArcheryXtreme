//
//  TargetObject.m
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "TargetObject.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "AppDelegate.h"

CGSize ws;
@implementation TargetObject
@synthesize spx,spy,vy,baseSpy,delay,baseX,vr,isDead;

-(id) initWithIndex:(int)idx
{
	if( (self=[super init]) )
    {
        self.isDead=NO;
        self.baseSpy=10;
        ws=[[CCDirector sharedDirector]winSize];

        m_scaleX = ws.width / 480.0f;
        m_scaleY = ws.height / 320.0f;
        
        m_idx = idx;
        self.baseX=ws.width - 100 * m_scaleX;
        m_fruitType = arc4random()%15;
        CCSprite *obj= nil;
        if (arc4random() % 100 < 10)
        {
            m_isGold = true;
            obj = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"gold apple.png"]];
        }
        else
            obj = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"object%04d.png",m_fruitType + 1]];
        [self addChild:obj];
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (app->m_playMode == MultiPlayWithGameCenter)
            [app->m_gameCenterManager SendCatapult:idx type:m_fruitType];
        m_bCreatedByOwn = true;
        [self initState];
        [self schedule:@selector(loop)];
    }
    return self;
}

-(id)initFromServer:(int)_idx type:(int)fruitType
{
    if( (self=[super init]) ) {
        self.isDead=NO;
        self.baseSpy=8;
        ws=[[CCDirector sharedDirector]winSize];
        m_idx = _idx;
        self.baseX = ws.width - 100 * m_scaleY;
        m_fruitType = fruitType;
        m_bCreatedByOwn = false;
        CCSprite *obj=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"object%04d.png",m_fruitType + 1]];
        [self addChild:obj];
    }
    return self;
}

-(void)dealloc
{
    [self unschedule:@selector(loop)];
    [super dealloc];
}

-(void)ResumeSchedule
{
    [self schedule:@selector(loop)];
}

-(float)RandomPercent
{
    return (arc4random()%100) /100;
}

-(void)initState
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.delay = [self RandomPercent] * 600;
    self.spy = self.baseSpy - (self.baseSpy / 3) * (((float)(arc4random() % 100)) / 100) + app->m_gameMain->currentLevel * 0.5f;
    
    self.spx = [self RandomPercent] * 2.0f;
    self.spx -= 1;
    
    self.vy = (-0.12f - app->m_gameMain->currentLevel * 0.03f);
    self.vr=(float)(arc4random()%100)/100.0f;
    self.vr=self.vr*2;
    self.vr+=0.3;
    
    self.position=ccp(self.baseX, -20 * m_scaleY);
    if (app->m_playMode == MultiPlayWithGameCenter)
        [app->m_gameCenterManager SendFruitInfo:self.delay ySpeed:spy xSpeed:spx angelSpeed:vr index:m_idx];
    
    self.spy = self.spy * m_scaleY;
    self.spx = self.spx * m_scaleX;
    self.vr = self.vr * m_scaleY;
    self.vy = self.vy * m_scaleY;
}

//main loop
-(void)loop{
    
    if (self.isDead) {
        [self unschedule:@selector(loop)];
        return;
    }
    if(self.delay<0){
    
        self.position=ccp(self.position.x+spx,self.position.y+self.spy);
        self.spy+=self.vy;
        self.rotation+=self.vr;

        if (self.spy < 0 && self.position.y < (-100 * m_scaleY) && m_bCreatedByOwn)
            [self initState];
    }
    else{
        self.delay--;
    }
}

-(void)UpdatePosAndAngle:(CGPoint)pos angle:(float)ang
{
    self.position = pos;
    self.rotation = ang;
}

-(void)initStateWithOption:(int)_delay ySpeed:(float)_spy xSpeed:(float)_spx angleSpeed:(float)_vr
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.delay = delay;
    self.spy = _spy;
    self.spx = _spx;
    self.spx-=1;
    self.vy = -0.12f - app->m_gameMain->currentLevel * 0.03f;
    self.vr = _vr;
    self.position=ccp(self.baseX, -20 * m_scaleY);
    
    self.spy = self.spy * m_scaleY;
    self.spx = self.spx * m_scaleX;
    self.vr = self.vr * m_scaleY;
    self.vy = self.vy * m_scaleY;
    if (!m_bStartedSchedule)
    {
        m_bStartedSchedule = true;
        [self schedule:@selector(loop)];
    }
}
@end
