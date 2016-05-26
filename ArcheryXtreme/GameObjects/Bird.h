//
//  Bird.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
@interface Bird : CCSprite{
    CCSprite *mc;
    CCAnimate *ate;
    CCAnimation *ani;
    NSMutableArray *aniArr;
    float speed;
}
-(void)startMoveWithSpeed:(float)sp;
-(void)loop;
@property(nonatomic,retain) CCSprite *mc;
@property(nonatomic,assign) float speed;
@property(nonatomic,retain) CCAnimate *ate;
@property(nonatomic,retain) CCAnimation *ani;
@property(nonatomic,retain) NSMutableArray *aniArr;
@end
