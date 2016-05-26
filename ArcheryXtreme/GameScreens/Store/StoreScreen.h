//
//  StoreScreen.h
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/23/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "ArrowPurchaseLayer.h"
#import "BowPurchaseLayer.h"
#import "CoinPurchaseLayer.h"

@interface StoreScreen : CCLayer
{
    BowPurchaseLayer* m_bowPurchase;
    ArrowPurchaseLayer* m_arrowPurchase;
    CoinPurchaseLayer* m_coinPurchase;
    CCSprite*           m_background;
    CCSprite*           m_title;
    CCLabelBMFont*      lbl_coinScore;
    CCLabelBMFont*      lbl_arrowPackCount;
    float   m_scaleX;
    float   m_scaleY;
@public
    int             m_fromWhere;
}

-(void)UpdateStore;
@end
