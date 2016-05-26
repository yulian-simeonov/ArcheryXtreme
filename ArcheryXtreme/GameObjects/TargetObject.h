//
//  TargetObject.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCSprite.h"
#import "GameMain.h"
@interface TargetObject : CCSprite{
    float spx;
    float spy;
    float vy;
    float baseSpy;
    int delay,baseX;
    float vr;
    BOOL isDead;
    BOOL    m_bStartedSchedule;
    BOOL    m_bCreatedByOwn;
    float   m_scaleX;
    float   m_scaleY;
@public
    int     m_fruitType;
    int     m_idx;
    BOOL    m_isGold;
}
-(id) initWithIndex:(int)idx;
-(id)initFromServer:(int)_idx type:(int)fruitType;
-(void)initStateWithOption:(int)_delay ySpeed:(float)_spy xSpeed:(float)_spx angleSpeed:(float)_vr;
-(void)UpdatePosAndAngle:(CGPoint)pos angle:(float)ang;
-(void)loop;
-(void)ResumeSchedule;

@property(nonatomic,assign) float spx,spy,vy,baseSpy,vr;
@property(nonatomic,assign) int delay,baseX;
@property(nonatomic,assign) BOOL isDead;
 
@end
