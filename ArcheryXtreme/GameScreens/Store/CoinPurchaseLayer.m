//
//  CoinPurchaseLayer.m
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/23/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "CoinPurchaseLayer.h"
#import "StoreScreen.h"
#import "AppDelegate.h"

@implementation CoinPurchaseLayer
@synthesize delegate;

-(id)init
{
    if (self = [super init])
    {
        CGSize ws = [[CCDirector sharedDirector] winSize];
        m_scaleX = ws.width / 480.0f;
        m_scaleY = ws.height / 320.0f;
        
        for (int i = 0; i < 4; i++)
        {
            m_goldCoins[i] = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%dFruitCoin.png", i + 2]];
            [m_goldCoins[i] setPosition:ccp(280 * m_scaleX, 150 * m_scaleY)];
            
            m_coinScores[i] = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"coins%d.png", i + 1]];
            [m_coinScores[i] setPosition:ccp(280 * m_scaleX, 70 * m_scaleY)];
            [self addChild:m_goldCoins[i]];
            [self addChild:m_coinScores[i]];
        }
        
        CCSprite* spriteBtnBuy1 = [CCSprite spriteWithSpriteFrameName:@"btn_buy.png"];
        CCSprite* spriteBtnBuy2 = [CCSprite spriteWithSpriteFrameName:@"btn_buy.png"];
        CCMenuItemSprite* btnBuy = [CCMenuItemSprite itemWithNormalSprite:spriteBtnBuy1 selectedSprite:spriteBtnBuy2];
        [btnBuy setTarget:self selector:@selector(OnBuy)];
        
        CCSprite* spriteBtnLeft1 = [CCSprite spriteWithSpriteFrameName:@"arrow_left.png"];
        CCSprite* spriteBtnLeft2 = [CCSprite spriteWithSpriteFrameName:@"arrow_left.png"];
        CCMenuItemSprite* btnLeft = [CCMenuItemSprite itemWithNormalSprite:spriteBtnLeft1 selectedSprite:spriteBtnLeft2];
        [btnLeft setPosition:ccp(-120 * m_scaleX, 100 * m_scaleY)];
        [btnLeft setTarget:self selector:@selector(OnLeft)];
        
        CCSprite* spriteBtnRight1 = [CCSprite spriteWithSpriteFrameName:@"arrow_right.png"];
        CCSprite* spriteBtnRight2 = [CCSprite spriteWithSpriteFrameName:@"arrow_right.png"];
        CCMenuItemSprite* btnRight = [CCMenuItemSprite itemWithNormalSprite:spriteBtnRight1 selectedSprite:spriteBtnRight2];
        [btnRight setPosition:ccp(120 * m_scaleX, 100 * m_scaleY)];
        [btnRight setTarget:self selector:@selector(OnRight)];
        
        CCMenu* menu = [CCMenu menuWithItems:btnBuy, btnLeft, btnRight, nil];
        [menu setPosition:ccp(280 * m_scaleX, 50 * m_scaleY)];
        [self addChild:menu];
        m_curIdx = 0;
        [self ShowCurrentCoin];
    }
    return self;
}

-(void)ShowCurrentCoin
{
    for(int i = 0; i < 4; i++)
    {
        [m_goldCoins[i] setVisible:FALSE];
        [m_coinScores[i] setVisible:FALSE];
    }
    [m_goldCoins[m_curIdx] setVisible:TRUE];
    [m_coinScores[m_curIdx] setVisible:TRUE];
}

-(void)OnBuy
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app ShowWaiter];
    [[MKStoreManager sharedManager] BuyCoint:m_curIdx + 1];
    [MKStoreManager sharedManager]->delegate = self;
    ((StoreScreen*)delegate).isTouchEnabled = false;
}

-(void)OnLeft
{
    m_curIdx--;
    if (m_curIdx < 0)
        m_curIdx = 0;
    [self ShowCurrentCoin];
}

-(void)OnRight
{
    m_curIdx++;
    if (m_curIdx > 3)
        m_curIdx = 3;
    [self ShowCurrentCoin];
}

-(void)SuccessfullyPurchased:(int)score
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app->m_coinScore += score;
    [(StoreScreen*)delegate UpdateStore];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:app->m_coinScore] forKey:@"GoldCoin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
