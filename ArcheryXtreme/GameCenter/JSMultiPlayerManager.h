//
//  JSMultiPlayerManager.h
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/21/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GCHelper.h"

enum CmdType {
    ArrowPos, FruitInfo, CatapultFruit, ExploseFruit, StartFlag, GameOverFlag, PlayAgainFlag
};

@interface JSMultiPlayerManager : NSObject<GCHelperDelegate>
{}
@property (nonatomic) BOOL isServer;

-(void)SendBowAngle:(float)angle;
-(void)SendFruitInfo:(int)delay ySpeed:(float)spy xSpeed:(float)spx angelSpeed:(float)vr index:(int)idx;
-(void)SendCatapult:(int)index type:(int)fruitType;
-(void)SendExplose:(int)index;
-(void)SendStartFlag:(unsigned char)flag;
-(void)SendGameOver:(int)score;
-(void)SendPlayAgain;
@end
