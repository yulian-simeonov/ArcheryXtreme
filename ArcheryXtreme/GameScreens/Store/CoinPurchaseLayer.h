//
//  CoinPurchaseLayer.h
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/23/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "cocos2d.h"
#import "CCLayer.h"
#import "MKStoreManager.h"

@interface CoinPurchaseLayer : CCLayer
{
    CCSprite* m_goldCoins[4];
    CCSprite* m_coinScores[4];
    int     m_curIdx;
    float   m_scaleX;
    float   m_scaleY;
}

@property (nonatomic, retain) id delegate;

-(void)SuccessfullyPurchased:(int)score;
-(void)OnBuy;
@end
