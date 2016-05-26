//
//  NextPeerManager.m
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/31/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "NextPeerManager.h"
#import "NPCocosNotifications.h"
#import "AppDelegate.h"
#import "GameMain.h"
#import "TargetObject.h"
#import "GameIntro.h"
#import "GameIntro.h"

@implementation NextPeerManager
@synthesize isServer;

-(id)init
{
    if (self = [super init])
    {
        NPCocosNotifications *notifications = [NPCocosNotifications sharedManager];
        [[CCDirector sharedDirector] setNotificationNode:notifications];
        [notifications setPosition:kNPCocosNotificationPositionTop];
        [self initializeNextpeer];
        isServer = false;
    }
    return self;
}
//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// Nextpeer: Initialize Nextpeer with your product key and the display name.
- (void)initializeNextpeer
{
	NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              
                              // This game has no retina support - therefore we have to let the platform know
                              [NSNumber numberWithBool:FALSE], NextpeerSettingGameSupportsRetina,
                              // Support orientation change for the dashboard notifications
                              [NSNumber numberWithBool:TRUE], NextpeerSettingSupportsDashboardRotation,
                              // Support orientation change for the in game notifications
                              [NSNumber numberWithBool:TRUE], NextpeerSettingObserveNotificationOrientationChange,
                              //  Place the in game notifications on the bottom screen (so the current score will be visible)
							  [NSNumber numberWithInt:NPNotificationPosition_BOTTOM], NextpeerSettingNotificationPosition,
							  nil];
	
	
	[Nextpeer initializeWithProductKey:@"6d4135908d5c9db50d927ffb04d797f307b08cd1" andSettings:settings andDelegates:
     [NPDelegatesContainer containerWithNextpeerDelegate:self notificationDelegate:[NPCocosNotifications sharedManager] tournamentDelegate:self]];
}
//------------------------------------------------------------------------------//

#pragma mark NextpeercDelegate methods

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// Nextpeer: This delegate method will be called once the user is about to start a
//            tournament with the given id.
// @note: If your game supports more than one type of tournament, you should use tournamentUuid to start the right one.
-(void)nextpeerDidTournamentStartWithDetails:(NPTournamentStartDataContainer *)tournamentContainer {
    
    // Set the game's random based on the shared seed (so all players will see the same type of game)
    srandom(tournamentContainer.tournamentRandomSeed);
    
//    gGameIsLastManStanding = [tournamentContainer tournamentIsGameControlled];
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
//------------------------------------------------------------------------------//

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// Nextpeer: This delegate method will be called once the time for the current ongoing game is up.
// You should stop the game when this method is called.
-(void)nextpeerDidTournamentEnd {
    [[NPCocosNotifications sharedManager] clearAndDismiss];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [Nextpeer reportScoreForCurrentTournament:app->m_gameMain->score];
    if (app->m_gameMain != nil)
    {
        [app->m_gameMain release];
        app->m_gameMain = nil;
    }
    
    [[CCDirector sharedDirector] replaceScene:[GameIntro scene]];
}
//------------------------------------------------------------------------------//

//------------------------------- Nextpeer SDK ---------------------------------//
-(BOOL)nextpeerSupportsTournamentWithId:(NSString* )tournamentUuid {
    // We supports only this type of tournament in the current version, block all others!
    return ([tournamentUuid isEqualToString:@"NPA94711737051763564"]);
}

//------------------------------------------------------------------------------//

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// In order to improve rendering performance we will need to pause the CCDirector prior to the dashboard launch
- (void)nextpeerDashboardWillAppear {
	[[CCDirector sharedDirector] pause];
}
//------------------------------------------------------------------------------//

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// We can now resume the CCDirector as the dashboard disappeared
- (void)nextpeerDashboardDidDisappear {
	[[CCDirector sharedDirector] resume];
}
//------------------------------------------------------------------------------//

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
-(void)nextpeerDidReceiveTournamentCustomMessage:(NPTournamentCustomMessageContainer*)message
{
}
//------------------------------------------------------------------------------//

@end
