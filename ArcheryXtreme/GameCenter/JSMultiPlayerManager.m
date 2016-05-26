//
//  JSMultiPlayerManager.m
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/21/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "JSMultiPlayerManager.h"
#import "AppDelegate.h"
#import "GameMain.h"
#import "TargetObject.h"
#import "GameIntro.h"

@implementation JSMultiPlayerManager
@synthesize isServer;

-(id)init
{
    if (self = [super init])
    {
        [[GCHelper sharedInstance] setDelegate:self];
        isServer = false;
    }
    return self;
}

- (void)matchStarted;
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app->m_gameMain != nil)
    {
        [app->m_gameMain release];
        app->m_gameMain = nil;
    }
    app->m_gameMain = [[GameMain alloc] init];
    app->m_playMode = MultiPlayWithGameCenter;
    if (isServer)
        [self SendStartFlag:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:(CCScene*)app->m_gameMain]];
}

- (void)matchEnded
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app->m_gameMain != nil)
    {
        [app->m_gameMain release];
        app->m_gameMain = nil;
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameIntro scene]]];
}

-(NSArray*)GetPlayers
{
    GKMatch* match = [[GCHelper sharedInstance] match];
    return [match playerIDs];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    unsigned char*  receivedBuf = (unsigned char*)[data bytes];

    switch (receivedBuf[0]) {
        case ArrowPos:
        {
            float angle;
            memcpy(&angle, receivedBuf + 1, 4);
            [app->m_gameMain shootByOpponent:angle];
            break;
        }
        case FruitInfo:
        {
            int index, delay;
            float spy, spx, vr;
            memcpy(&delay, receivedBuf + 1, 4);
            memcpy(&spy, receivedBuf + 5, 4);
            memcpy(&spx, receivedBuf + 9, 4);
            memcpy(&vr, receivedBuf + 13, 4);
            memcpy(&index, receivedBuf + 17, 4);
            for (TargetObject* fruit in app->m_gameMain->objArr)
            {
                if (fruit->m_idx == index)
                {
                    [fruit initStateWithOption:delay ySpeed:spy xSpeed:spx angleSpeed:vr];
                    break;
                }
            }
            break;
        }
        case CatapultFruit:
        {
            int idx, type;
            memcpy(&idx, receivedBuf + 1, 4);
            memcpy(&type, receivedBuf + 5, 4);
            [app->m_gameMain catapultObjectFromServer:idx type:type];
            break;
        }
        case ExploseFruit:
        {
            int index;
            memcpy(&index, receivedBuf + 1, 4);
            [app->m_gameMain RemoveFruit:index];
            break;
        }
        case StartFlag:
        {
            unsigned char flag = receivedBuf[1];
            if (app->m_gameMain)
            {
                if(app->m_gameMain->m_isReady)
                {
                    if (flag == 1)
                    {
                        if (!app->m_gameMain->m_isStarted)
                        {
                            [app->m_gameMain StartGame];
                            [self SendStartFlag:1];
                        }
                    }
                    else
                        [self SendStartFlag:1];
                }
                else
                    [self SendStartFlag:0];
            }
            else
                [self SendStartFlag:0];
            break;
        }
        case GameOverFlag:
        {
            int score;
            memcpy(&score, receivedBuf + 1, 4);
            [app->m_gameMain MultiPlayGameOver:score];
            if (!app->m_gameMain->m_isOver)
                [self SendGameOver:app->m_gameMain->score];
            break;
        }
        case PlayAgainFlag:
        {
            if (app->m_gameMain != nil)
            {
                [app->m_gameMain release];
                app->m_gameMain = nil;
            }
            app->m_gameMain = [[GameMain alloc] init];
            if (isServer)
                [self SendStartFlag:1];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:(CCScene*)app->m_gameMain]];
            break;
        }
        default:
            break;
    }
}

-(void)SendBowAngle:(float)angle
{
    unsigned char sendbuf[5];
    sendbuf[0] = ArrowPos;
    memcpy(sendbuf + 1, &angle, 4);
    NSData* sendBuf = [NSData dataWithBytes:&sendbuf length:5];
    GKMatch* match = [[GCHelper sharedInstance] match];
    [match sendDataToAllPlayers:sendBuf withDataMode:GKMatchSendDataReliable error:nil];
}

-(void)SendFruitInfo:(int)delay ySpeed:(float)spy xSpeed:(float)spx angelSpeed:(float)vr index:(int)idx
{
    unsigned char sendbuf[21];
    sendbuf[0] = FruitInfo;
    memcpy(sendbuf + 1, &delay, 4);
    memcpy(sendbuf + 5, &spy, 4);
    memcpy(sendbuf + 9, &spx, 4);
    memcpy(sendbuf + 13, &vr, 4);
    memcpy(sendbuf + 17, &idx, 4);
    NSData* sendBuf = [NSData dataWithBytes:&sendbuf length:21];
    GKMatch* match = [[GCHelper sharedInstance] match];
    [match sendDataToAllPlayers:sendBuf withDataMode:GKMatchSendDataReliable error:nil];
}

-(void)SendCatapult:(int)index type:(int)fruitType
{
    unsigned char sendbuf[9];
    sendbuf[0] = CatapultFruit;
    memcpy(sendbuf + 1, &index, 4);
    memcpy(sendbuf + 5, &fruitType, 4);
    NSData* sendBuf = [NSData dataWithBytes:&sendbuf length:9];
    GKMatch* match = [[GCHelper sharedInstance] match];
    [match sendDataToAllPlayers:sendBuf withDataMode:GKMatchSendDataReliable error:nil];
}

-(void)SendExplose:(int)index
{
    unsigned char sendbuf[5];
    sendbuf[0] = ExploseFruit;
    memcpy(sendbuf + 1, &index, 4);
    NSData* sendBuf = [NSData dataWithBytes:&sendbuf length:5];
    GKMatch* match = [[GCHelper sharedInstance] match];
    [match sendDataToAllPlayers:sendBuf withDataMode:GKMatchSendDataReliable error:nil];
}

-(void)SendStartFlag:(unsigned char)flag
{
    unsigned char sendbuf[2];
    sendbuf[0] = StartFlag;
    sendbuf[1] = flag;
    NSData* sendBuf = [NSData dataWithBytes:&sendbuf length:2];
    GKMatch* match = [[GCHelper sharedInstance] match];
    [match sendDataToAllPlayers:sendBuf withDataMode:GKMatchSendDataReliable error:nil];
}

-(void)SendGameOver:(int)score
{
    unsigned char sendbuf[5];
    sendbuf[0] = GameOverFlag;
    memcpy(sendbuf + 1, &score, 4);
    NSData* sendBuf = [NSData dataWithBytes:&sendbuf length:5];
    GKMatch* match = [[GCHelper sharedInstance] match];
    [match sendDataToAllPlayers:sendBuf withDataMode:GKMatchSendDataReliable error:nil];
}

-(void)SendPlayAgain
{
    unsigned char sendbuf[1];
    sendbuf[0] = PlayAgainFlag;
    NSData* sendBuf = [NSData dataWithBytes:&sendbuf length:1];
    GKMatch* match = [[GCHelper sharedInstance] match];
    [match sendDataToAllPlayers:sendBuf withDataMode:GKMatchSendDataReliable error:nil];
}
@end
