//
//  ArrowPurchaseLayer.m
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/23/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "ArrowPurchaseLayer.h"
#import "AppDelegate.h"
#import "StoreScreen.h"

@implementation ArrowPurchaseLayer
@synthesize delegate;

-(id)init
{
    if (self = [super init])
    {
        CGSize ws = [[CCDirector sharedDirector] winSize];
        m_scaleX = ws.width / 480.0f;
        m_scaleY = ws.height / 320.0f;
        
        CCMenuItemSprite* btn_purchase_arrow[4];

        float xOffset = 200 * m_scaleX, xDistance = 120 * m_scaleX, yDistance = 130 * m_scaleY;
        for (int i = 0; i < 4; i++)
        {
            CCSprite *coins = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"coins%d.png", i + 1]];
            
            btn_purchase_arrow[i] = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_select.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_select.png"]];
            CCSprite* arrowPack = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"arrowsbox_%d.png", i + 1]];
            
            [coins setAnchorPoint:ccp(0, 0.5f)];
            [coins setPosition:ccp(i % 2 * xDistance + 165 * m_scaleX, (1 - i / 2) * yDistance + 40 * m_scaleY)];
            [btn_purchase_arrow[i] setPosition:ccp(i % 2 * xDistance + xOffset, (1 - i / 2) * yDistance)];
            [btn_purchase_arrow[i] setTarget:self selector:@selector(OnSelect:)];
            [btn_purchase_arrow[i] setTag:i];
            
            [arrowPack setPosition:ccp(i % 2 * xDistance + xOffset, (1 - i / 2) * yDistance + 90 * m_scaleY)];
            [self addChild:coins];
            [self addChild:arrowPack];
        }
        
        CCMenu* menu = [CCMenu menuWithItems:btn_purchase_arrow[0], btn_purchase_arrow[1], btn_purchase_arrow[2], btn_purchase_arrow[3], nil];
        [menu setPosition:ccp(-10 * m_scaleX, 20 * m_scaleY)];
        [self addChild:menu];
    }
    return self;
}

-(void)OnSelect:(id)sender
{
    StoreScreen* parent = (StoreScreen*)delegate;
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    int selectedIdx = ((CCMenuItemSprite*)sender).tag;
    switch (selectedIdx) {
        case 0:
        {
            if (app->m_coinScore >= 500)
            {
                app->m_coinScore -= 500;
                app->m_arrowPackCount += 1;
            }
            break;
        }
        case 1:
        {
            if (app->m_coinScore >= 2200)
            {
                app->m_coinScore -= 2200;
                app->m_arrowPackCount += 5;
            }
            break;
        }
        case 2:
        {
            if (app->m_coinScore >= 4000)
            {
                app->m_coinScore -= 4000;
                app->m_arrowPackCount += 10;
            }
            break;
        }
        case 3:
        {
            if (app->m_coinScore >= 10000)
            {
                app->m_coinScore -= 10000;
                app->m_arrowPackCount += 25;
            }
            break;
        }
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:app->m_coinScore] forKey:@"GoldCoin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [parent UpdateStore];
}
@end
