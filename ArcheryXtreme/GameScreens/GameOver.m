//
//  GameOver.m
//  BowHunting
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "GameOver.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "Clouds.h"
#import "GameIntro.h"
#import "AppDelegate.h"

CGSize ws;
@implementation GameOver

-(id) initWithScore:(int)score opponentScore:(int)sndScore
{
	if( (self=[super init]))
    {
        ws=[[CCDirector sharedDirector]winSize];
        
        CCSprite *sky=[CCSprite spriteWithFile:@"gameOverSky.png"];
        sky.position=ccp(ws.width/2,ws.height/2);
        [self addChild:sky];
        
        Clouds *c=[[Clouds alloc]init];
        c.position=ccp(0,ws.height);
        [self addChild:c];
        
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (app->m_playMode == SinglePlay)
        {
            CCSprite *gameOverSprite=[CCSprite spriteWithSpriteFrameName:@"gameOverTitle.png"];
                    
            gameOverSprite.position=ccp(ws.width/2,ws.height/2+90);
             
            [self addChild:gameOverSprite];
            
            CCLabelBMFont* scoreText = scoreText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Score:%d", score] fntFile:@"CooperBlack.fnt"];
            scoreText.position=ccp(ws.width/2,ws.height/2+20);
            [self addChild:scoreText];
            
            CCMenuItem* btnMainMenu = [CCMenuItemFont itemWithString:@"Main Menu" target:self selector:@selector(OnMainMenu)];
            [btnMainMenu setAnchorPoint:CGPointMake(0, 1)];
            [btnMainMenu setScale:0.5f];
            [btnMainMenu setPosition:CGPointMake(10, 310)];
            
            CCMenuItem* btnPlayAgain = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_play_again1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_play_again2.png"] target:self selector:@selector(playAgianButtonClicked)];
            btnPlayAgain.position=ccp(ws.width*0.5,ws.height/2-20);
            
            CCMenuItem *btnMoreApp=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"moreApps0001.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"moreApps0002.png"] target:self selector:@selector(moreAppsButtonClicked)];

            btnMoreApp.position=ccp(ws.width/2,ws.height/2-80);
            
            CCMenuItem *btnMyWebSite=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"myWebsite0001.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"myWebsite0002.png"] target:self selector:@selector(myWebsiteButtonClicked)];
            btnMyWebSite.position=ccp(ws.width/2,ws.height/2-130);
            
            CCMenu *menu=[CCMenu menuWithItems:btnMainMenu, btnPlayAgain, btnMoreApp, btnMyWebSite, nil];
            [menu setPosition:CGPointMake(0, 0)];
            [self addChild:menu];
        }
        else
        {
            NSString* strResult = nil;
            if (score > sndScore)
            {
                strResult = @"You Won";
            }
            else if (score < sndScore)
            {
                strResult = @"You Failed";
            }
            else
                strResult = @"You are equal.";
            CCLabelBMFont* resultText = [CCLabelBMFont labelWithString:strResult fntFile:@"CooperBlack.fnt"];
            resultText.position=ccp(ws.width/2,ws.height/2+90);
            [resultText setScale:2];
            [self addChild:resultText];
            
            CCLabelBMFont* sndScoreText = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Opponent Score:%d", sndScore] fntFile:@"CooperBlack.fnt"];
            sndScoreText.position=ccp(ws.width/2,ws.height/2+50);
            [self addChild:sndScoreText];
            
            CCLabelBMFont* scoreText = scoreText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"My Score:%d", score] fntFile:@"CooperBlack.fnt"];
            scoreText.position=ccp(ws.width/2,ws.height/2+20);
            [self addChild:scoreText];
            
            CCMenuItem* btnPlayAgain = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_play_again1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_play_again2.png"] target:self selector:@selector(playAgianButtonClicked)];
            btnPlayAgain.position=ccp(ws.width*0.5,ws.height/2-20);
            
            CCMenuItem* btnMainMenu = [CCMenuItemFont itemWithString:@"Main Menu" target:self selector:@selector(OnMainMenu)];
            [btnMainMenu setPosition:ccp(ws.width*0.5,ws.height/2-60)];
            CCMenu *menu=[CCMenu menuWithItems:btnMainMenu, btnPlayAgain, nil];
            [menu setPosition:CGPointMake(0, 0)];
            [self addChild:menu];
        }
    }
    return self;
}

//play again button clicked , start a new game
-(void)OnMainMenu
{
    [[[GCHelper sharedInstance] match] disconnect];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameIntro scene]]];
}

-(void)playAgianButtonClicked
{

    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app->m_gameMain != nil)
    {
        [app->m_gameMain release];
        app->m_gameMain = nil;
    }
    app->m_gameMain = [[GameMain alloc] init];
    if (app->m_playMode == SinglePlay)
    {
        [app->m_gameMain StartGame];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:(CCScene*)app->m_gameMain]];
    }
    else
    {
        [app->m_gameCenterManager SendPlayAgain];
        if (app->m_gameCenterManager.isServer)
            [app->m_gameCenterManager SendStartFlag:1];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:(CCScene*)app->m_gameMain]];
    }
}

-(void)moreAppsButtonClicked{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GameIntro getMoreAppsURL]]];
}
-(void)myWebsiteButtonClicked{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GameIntro getMyWebsiteURL]]];
}

@end
