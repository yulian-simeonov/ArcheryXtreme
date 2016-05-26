//
//  StoreScreen.m
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/23/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "StoreScreen.h"
#import "AppDelegate.h"
#import "GameMain.h"

@implementation StoreScreen
-(id)init
{
    if (self = [super init])
    {
        CGSize ws = [[CCDirector sharedDirector] winSize];
        m_scaleX = ws.width / 480.0f;
        m_scaleY = ws.height / 320.0f;
        
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        m_background = [CCSprite spriteWithFile:@"purchase_coin_background.png"];
        [m_background setScaleX:1.5f];
        [m_background setPosition:ccp(ws.width / 2, ws.height / 2)];
        [self addChild:m_background];

        m_title = [CCSprite spriteWithSpriteFrameName:@"ReloadPacksTitle.png"];
        [m_title setAnchorPoint:ccp(0, 0.5f)];
        [m_title setPosition:ccp(10 * m_scaleX, 300 * m_scaleY)];
        [self addChild:m_title];
        
        CCSprite* goldCoin = [CCSprite spriteWithSpriteFrameName:@"FruitCoin.png"];
        [goldCoin setScale:0.4f];
        [goldCoin setPosition:ccp(380 * m_scaleX, 290 * m_scaleY)];
        [self addChild:goldCoin];
        
        CCSprite* arrowPack = [CCSprite spriteWithSpriteFrameName:@"arrow_pack.png"];
        [arrowPack setPosition:ccp(380 * m_scaleX, 250 * m_scaleY)];
        [self addChild:arrowPack];
        
        lbl_coinScore=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", app->m_coinScore] fntFile:@"CooperBlack.fnt"];
        [lbl_coinScore setAnchorPoint:ccp(0, 0.5f)];
        [lbl_coinScore setPosition:ccp(400 * m_scaleX, 290 * m_scaleY)];
        [self addChild:lbl_coinScore];
        
        lbl_arrowPackCount=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"X%d", app->m_arrowPackCount] fntFile:@"CooperBlack.fnt"];
        [lbl_arrowPackCount setAnchorPoint:ccp(0, 0.5f)];
        [lbl_arrowPackCount setPosition:ccp(400 * m_scaleX, 250 * m_scaleY)];
        [self addChild:lbl_arrowPackCount];
        
//        CCSprite* spriteBtnBow1 = [CCSprite spriteWithSpriteFrameName:@"btn_bow.png"];
//        CCSprite* spriteBtnBow2 = [CCSprite spriteWithSpriteFrameName:@"btn_bow.png"];
//        CCMenuItemSprite* btnBow = [CCMenuItemSprite itemWithNormalSprite:spriteBtnBow1 selectedSprite:spriteBtnBow2];
//        [btnBow setPosition:ccp(30 * m_scaleX, 200 * m_scaleY)];
//        [btnBow setTag:1];
//        [btnBow setTarget:self selector:@selector(OnSelectLayer:)];

        CCSprite* spriteBtnArrowPack1 = [CCSprite spriteWithSpriteFrameName:@"btn_arrow.png"];
        CCSprite* spriteBtnArrowPack2 = [CCSprite spriteWithSpriteFrameName:@"btn_arrow.png"];
        CCMenuItemSprite* btnArrowPack = [CCMenuItemSprite itemWithNormalSprite:spriteBtnArrowPack1 selectedSprite:spriteBtnArrowPack2];
        [btnArrowPack setPosition:ccp(30 * m_scaleX, 180 * m_scaleY)];
        [btnArrowPack setTag:2];
        [btnArrowPack setTarget:self selector:@selector(OnSelectLayer:)];
        
        CCSprite* spriteBtnCoin1 = [CCSprite spriteWithSpriteFrameName:@"btn_coins.png"];
        CCSprite* spriteBtnCoin2 = [CCSprite spriteWithSpriteFrameName:@"btn_coins.png"];
        CCMenuItemSprite* btnCoin = [CCMenuItemSprite itemWithNormalSprite:spriteBtnCoin1 selectedSprite:spriteBtnCoin2];
        [btnCoin setPosition:ccp(30 * m_scaleX, 100 * m_scaleY)];
        [btnCoin setTag:3];
        [btnCoin setTarget:self selector:@selector(OnSelectLayer:)];
        
        CCSprite* spriteBtnBack1 = [CCSprite spriteWithSpriteFrameName:@"btn_back.png"];
        CCSprite* spriteBtnBack2 = [CCSprite spriteWithSpriteFrameName:@"btn_back.png"];
        CCMenuItemSprite* btnBack = [CCMenuItemSprite itemWithNormalSprite:spriteBtnBack1 selectedSprite:spriteBtnBack2];
        [btnBack setPosition:ccp(40 * m_scaleX, 260 * m_scaleY)];
        [btnBack setTarget:self selector:@selector(OnBack)];
        
        CCMenu* menu = [CCMenu menuWithItems: btnArrowPack, btnCoin, btnBack, nil];
        [menu setPosition:ccp(10 * m_scaleX, 0)];
        [self addChild:menu];

        m_bowPurchase = [[BowPurchaseLayer alloc] init];
        m_arrowPurchase = [[ArrowPurchaseLayer alloc] init];
        [m_arrowPurchase setDelegate:self];

        m_coinPurchase = [[CoinPurchaseLayer alloc] init];
        [m_coinPurchase setDelegate:self];
        [self addChild:m_arrowPurchase];
        [self addChild:m_bowPurchase];
        [self addChild:m_coinPurchase];
        [self OnSelectLayer:btnArrowPack];
    }
    return self;
}

-(void)dealloc
{
    [m_bowPurchase release];
    [m_arrowPurchase release];
    [m_coinPurchase release];
    [super dealloc];
}

-(void)OnSelectLayer:(id)sender
{
    [m_bowPurchase setPosition:ccp(-500 * m_scaleX, m_bowPurchase.position.y)];
    [m_arrowPurchase setPosition:ccp(-500 * m_scaleX, m_bowPurchase.position.y)];
    [m_coinPurchase setPosition:ccp(-500 * m_scaleX, m_bowPurchase.position.y)];
    switch (((CCMenuItemSprite*)sender).tag)
    {
        case 1:
        {
            [m_bowPurchase setPosition:ccp(0, m_bowPurchase.position.y)];
            break;
        }
        case 2:
        {
            [m_title removeFromParentAndCleanup:TRUE];
            m_title = [CCSprite spriteWithSpriteFrameName:@"ReloadPacksTitle.png"];
            [m_title setAnchorPoint:ccp(0, 0.5f)];
            [m_title setPosition:ccp(10 * m_scaleX, 300 * m_scaleY)];
            [self addChild:m_title];
            [m_arrowPurchase setPosition:ccp(0, m_bowPurchase.position.y)];
            break;
        }
        case 3:
        {
            [m_title removeFromParentAndCleanup:TRUE];
            m_title = [CCSprite spriteWithSpriteFrameName:@"BuyFruitCoinsTitle.png"];
            [m_title setAnchorPoint:ccp(0, 0.5f)];
            [m_title setPosition:ccp(10 * m_scaleX, 300 * m_scaleY)];
            [self addChild:m_title];
            [m_coinPurchase setPosition:ccp(0, m_bowPurchase.position.y)];
        }
        default:
            break;
    }
}

-(void)UpdateStore
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [lbl_coinScore setString:[NSString stringWithFormat:@"%d", app->m_coinScore]];
    [lbl_arrowPackCount setString:[NSString stringWithFormat:@"X%d", app->m_arrowPackCount]];
}

-(void)OnBack
{
    ((CCLayer*)[self parent]).isTouchEnabled = true;
    if ([self.parent isKindOfClass:[GameMain class]])
    {
        [(GameMain*)self.parent ChangeStoreInfo];
    }
    [self removeFromParentAndCleanup:TRUE];
}
@end
