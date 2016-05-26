//
//  AppDelegate.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GCHelper.h"
#import "JSMultiPlayerManager.h"
#import "GameMain.h"
#import "StoreScreen.h"
#import "GameIntro.h"
#import "Nextpeer/Nextpeer.h"
#import "NextPeerManager.h"

enum PlayMode {
    SinglePlay = 0,
    MultiPlayWithGameCenter = 1,
    MultiPlayWithNextPeer = 2
    };

@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;

	CCDirectorIOS	*director_;							// weak ref
@public
    MyNavigationController *navController_;
    NextPeerManager*   m_nextPeerManager;
    JSMultiPlayerManager*   m_gameCenterManager;
    GameMain*       m_gameMain;
    enum PlayMode           m_playMode;
    int             m_coinScore;
    int             m_arrowPackCount;
    float           m_scaleX;
    float           m_scaleY;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

-(void)ShowWaiter;
-(void)HideWaiter;
@end
