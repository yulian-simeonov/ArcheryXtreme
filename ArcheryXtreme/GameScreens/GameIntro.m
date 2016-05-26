//
//  GameIntro.m
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "GameIntro.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "NextPeerManager.h"

CGSize ws;

@implementation GameIntro
@synthesize background,bunchMC;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	GameIntro *layer = [GameIntro node];
	
	[scene addChild: layer];
	return scene;
}


+(NSString *)getMoreAppsURL{
    return @"http://itunes.apple.com/us/app/fruit-ninja/id362949845?mt=8";
}
+(NSString *)getMyWebsiteURL{
    return @"http://conceptiondesigns.com";
}


// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init]) ) {
        
        ws=[[CCDirector sharedDirector]winSize];
        m_scaleX = ws.width / 480.0f;
        m_scaleY = ws.height / 320.0f;
        
        [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
		ws=[[CCDirector sharedDirector]winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheets.plist"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snd_move.wav"];
        
        //add background
		self.background=[CCSprite spriteWithFile:@"introBG.jpg"];
        self.background.position=ccp(ws.width/2,ws.height/2);
        [self addChild:self.background];
        
        CCSprite* spriteBtnPlay1 = [CCSprite spriteWithSpriteFrameName:@"btn_play.png"];
        CCSprite* spriteBtnPlay2 = [CCSprite spriteWithSpriteFrameName:@"btn_play.png"];
        CCMenuItem *btnPlay=[CCMenuItemSprite itemWithNormalSprite:spriteBtnPlay1
                                                    selectedSprite:spriteBtnPlay2 target:self selector:@selector(playButtonClicked)];
        [btnPlay setPosition:ccp(ws.width / 2 - (117 * m_scaleX), 130 * m_scaleY)];
        
        CCSprite* spriteBtnMultiPlay1 = [CCSprite spriteWithSpriteFrameName:@"btn_multiplayer_match.png"];
        CCSprite* spriteBtnMultiPlay2 = [CCSprite spriteWithSpriteFrameName:@"btn_multiplayer_match.png"];

        CCMenuItem *btnTwoPlayer=[CCMenuItemSprite itemWithNormalSprite:spriteBtnMultiPlay1
                                                    selectedSprite:spriteBtnMultiPlay2 target:self selector:@selector(OnTowPlayerMode)];
        [btnTwoPlayer setPosition:ccp(ws.width / 2 - (117 * m_scaleX), 85 * m_scaleY)];
        
        CCSprite* spritebtnMoreApp1 = [CCSprite spriteWithSpriteFrameName:@"btn_more_apps.png"];
        CCSprite* spritebtnMoreApp2 = [CCSprite spriteWithSpriteFrameName:@"btn_more_apps.png"];
        CCMenuItem *btnMoreApp=[CCMenuItemSprite itemWithNormalSprite:spritebtnMoreApp1
                                                       selectedSprite:spritebtnMoreApp2 target:self selector:@selector(moreAppsButtonClicked)];
        [btnMoreApp setPosition:ccp(ws.width / 2 - (117 * m_scaleX), 40 * m_scaleY)];

        CCSprite* spriteBtnStore1 = [CCSprite spriteWithSpriteFrameName:@"btn_store.png"];
        CCSprite* spriteBtnStore2 = [CCSprite spriteWithSpriteFrameName:@"btn_store.png"];
        CCMenuItem *btnStore=[CCMenuItemSprite itemWithNormalSprite:spriteBtnStore1
                                                     selectedSprite:spriteBtnStore2 target:self selector:@selector(storeClicked)];
        [btnStore setPosition:ccp(ws.width / 2 + (117 * m_scaleX), 130 * m_scaleY)];
        
        CCSprite* spriteBtnChallenge1 = [CCSprite spriteWithSpriteFrameName:@"btn_multiplayer_challenge.png"];
        CCSprite* spriteBtnChallenge2 = [CCSprite spriteWithSpriteFrameName:@"btn_multiplayer_challenge.png"];
        CCMenuItem *btnChallenge=[CCMenuItemSprite itemWithNormalSprite:spriteBtnChallenge1
                                                           selectedSprite:spriteBtnChallenge2 target:self selector:@selector(OnChallgneBase)];
        [btnChallenge setPosition:ccp(ws.width / 2 + (117 * m_scaleX), 85 * m_scaleY)];
        
        CCSprite* spriteBtnMyWebsite1 = [CCSprite spriteWithSpriteFrameName:@"btn_website.png"];
        CCSprite* spriteBtnMyWebsite2 = [CCSprite spriteWithSpriteFrameName:@"btn_website.png"];
        CCMenuItem *btnMyWebsite=[CCMenuItemSprite itemWithNormalSprite:spriteBtnMyWebsite1
                                                     selectedSprite:spriteBtnMyWebsite2 target:self selector:@selector(myWebsiteButtonClicked)];
        [btnMyWebsite setPosition:ccp(ws.width / 2 + (117 * m_scaleX), 40 * m_scaleY)];
        
        CCMenu* menu = [CCMenu menuWithItems:btnPlay, btnTwoPlayer, btnChallenge, btnStore, btnMoreApp, btnMyWebsite, nil];
        [menu setPosition:ccp(0, 0)];
        [self addChild:menu];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.wav" loop:YES];
	}
	return self;
}

-(void)playButtonClicked
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app->m_gameMain != nil)
    {
        [app->m_gameMain release];
        app->m_gameMain = nil;
    }
    app->m_gameMain = [[GameMain alloc] init];
    [app->m_gameMain StartGame];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:(CCScene*)app->m_gameMain]];
}

-(void)OnTowPlayerMode
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app->m_gameCenterManager.isServer = true;
    app->m_playMode = MultiPlayWithGameCenter;
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:app->navController_ delegate:app->m_gameCenterManager];
}

-(void)OnChallgneBase
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app->m_nextPeerManager.isServer = true;
    app->m_playMode = MultiPlayWithNextPeer;
    [Nextpeer launchDashboard];
}

-(void)storeClicked
{
    self.isTouchEnabled = false;
    [self addChild:[[[StoreScreen alloc] init] autorelease]];
}

-(void)moreAppsButtonClicked{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GameIntro getMoreAppsURL]]];
}
-(void)myWebsiteButtonClicked{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GameIntro getMyWebsiteURL]]];
}

-(NSUInteger)supportInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
