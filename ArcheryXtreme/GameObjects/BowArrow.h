//
//  BowArrow.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
@interface BowArrow : CCSprite{
    CCSprite *bow, *arrow;
    CCAnimate * bowMovie;
    
    CCAnimation * animObj;
    NSMutableArray *bowArr;
    
    BOOL shootAble;
    
   
}
-(void)playShootMovie;

@property(nonatomic,retain) CCSprite *bow,*arrow;
 @property(nonatomic,retain) NSMutableArray *bowArr;

@property(nonatomic,assign) CCAnimate *bowMovie;
@property(nonatomic,retain) CCAnimation *animObj;

@property(nonatomic,assign) BOOL shootAble;

@end
