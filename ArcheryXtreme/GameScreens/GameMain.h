//
//  HelloWorldLayer.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "BowArrow.h"
#import "Arrow.h"
#import "SwitchButton.h"
// HelloWorldLayer

enum GameState {
    GameOverState = 0,
    ShowLevelState = 1,
    StartNewLevelState = 2,
    NextLevelState = 3,
    NoArrow = 4,
    None = 5
};

@interface GameMain : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite *bgClip,*skyBG,*bgMC,*yun,*gameUICMC,*targetsCMC,*gameOverCMC, *arrowPack;
    CCLabelBMFont *scoreText,*timeText,*infoText, *highScoreText, *arrowCount, *lbl_arrowPackCount, *lbl_coinScore, *lbl_reload;
    BowArrow *bowArrow;
    BOOL gamePaused,currentArrowIsDead;
    int taskObjNum,limitTime,theTime,currentObjNum, highScore;
    NSMutableArray *arrowsArr;
    SwitchButton *musicBtn;
    CCSprite*   m_pauseScreen;
    CCSprite*   m_completedLevelScreen;
    UIImage *treeHT;
    int     m_arrowCount;
    int     m_scoreForLevel;
    int     m_baseTime;
    float   m_scaleX;
    float   m_scaleY;
@public
    int currentLevel;
    NSMutableArray* objArr;
    BOOL        m_isReady;
    BOOL        m_isStarted;
    int         score;
    BOOL        m_isOver;
}

-(void)StartGame;
-(void)catapultObjectFromServer:(int)idx type:(int)typ;
-(void)RemoveFruit:(int)index;
-(void)shootByOpponent:(float)angle;
-(void)ChangeStoreInfo;
-(void)MultiPlayGameOver:(int)opponentScore;
@end
