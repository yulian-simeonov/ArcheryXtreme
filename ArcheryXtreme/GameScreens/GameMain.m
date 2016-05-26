//
//  HelloWorldLayer.m
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

// Import the interfaces

#import "GameMain.h"
#import "Clouds.h"
#import "Bird.h"
#import "BowArrow.h"
#import "Arrow.h"
#import "TargetObject.h"
#import "GameOver.h"
#import <UIKit/UIKit.h>
#import "UIImage+ColorAtPixel.h"
#import "StoreScreen.h"

#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#pragma mark - HelloWorldLayer
CGSize ws;
static int scoreList[15] = {20, 80, 90, 120, 130, 150, 40, 70, 60, 140, 50, 110, 100, 95, 115};
@implementation GameMain

-(id) init
{
	if( (self=[super init]) )
    {
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        arrowsArr = [[NSMutableArray alloc] init];
        objArr = [[NSMutableArray alloc] init];
        m_isReady = false;
        ws=[[CCDirector sharedDirector]winSize];
        m_scaleX = ws.width / 480.0f;
        m_scaleY = ws.height / 320.0f;
        self.isTouchEnabled=YES;
        bgClip = [[[CCSprite alloc] init] autorelease];
        [self addChild:bgClip];
        
        gameUICMC=[[[CCSprite alloc]init] autorelease];
        [self addChild:gameUICMC];
        
        skyBG=[CCSprite spriteWithFile:@"skyBG.jpg"];
        skyBG.scaleX = ws.width / skyBG.contentSize.width;
        skyBG.anchorPoint=ccp(0.5,1);
        skyBG.position=ccp(ws.width/2,ws.height);
        [bgClip addChild:skyBG];
        
        //clouds
        yun=[[Clouds alloc]init];
        yun.position=ccp(0,ws.height);
        [bgClip addChild:yun];
        
        //birds
        for (int i=0; i<3; i++) {
            Bird *b=[[Bird alloc]init];
            b.position=ccp(arc4random()%(int)ws.width,arc4random()%(int)ws.height*3/5+ws.height*2/5-10);
            [b startMoveWithSpeed:arc4random()%100>50?-0.3-0.5*(arc4random()%100)/100:0.3+0.5*(arc4random()%100)/100 * m_scaleY];
            //b.scale=0.65;
            [bgClip addChild:b];
        }
        bgMC=[CCSprite spriteWithFile:@"background.png"];
        bgMC.position=ccp(ws.width/2,ws.height/2);
        [bgClip addChild:bgMC];
        
        //birds front
        for (int i=0; i<4; i++) {
            Bird *b=[[Bird alloc]init];
            b.position=ccp(arc4random()%(int)ws.width,arc4random()%(int)ws.height*3/5+ws.height*2/5-10);
            [b startMoveWithSpeed:arc4random()%100>50?-0.3-0.5*(arc4random()%100)/100:0.3+0.5*(arc4random()%100)/100 * m_scaleY];
            [bgClip addChild:b];
        }
        
        //Bow 
        bowArrow=[[[BowArrow alloc] init] autorelease];
        bowArrow.scale=0.65;
        bowArrow.position=ccp(40 * m_scaleX, 70 * m_scaleY);
        bowArrow.rotation=-18;
        [self addChild:bowArrow];
        
        //Info text
        infoText=[CCLabelBMFont labelWithString:@"Level 999 Complete!" fntFile:@"font2.fnt"];
        [timeText setString:[NSString stringWithFormat:@"Time:%i",limitTime]];
        infoText.string=@"";
        infoText.position=ccp(ws.width/2,ws.height/2);
        [infoText setScaleX:m_scaleX];
        [infoText setScaleY:m_scaleY];
        [gameUICMC addChild:infoText];
        
        targetsCMC=[[[CCSprite alloc]init] autorelease];
        [self addChild:targetsCMC];
        
        gameOverCMC=[[[CCSprite alloc]init] autorelease];
        [self addChild:gameOverCMC];
        
        musicBtn=[[[SwitchButton alloc] init] autorelease];
        [musicBtn initWithImageStr:@"musicOn1.png" O2:@"musicOn2.png" O3:@"musicOff1.png" O4:@"musicOff2.png" Open:YES];
         musicBtn.position=ccp(ws.width-(20 * m_scaleX), 20 * m_scaleY);
        [gameUICMC addChild:musicBtn];
        
        //Arrow Count text
        arrowCount = [CCLabelBMFont labelWithString:@"Arrows:30" fntFile:@"CooperBlack.fnt"];
        arrowCount.anchorPoint=ccp(0,0);
        [arrowCount setScale:0.7f];
        arrowCount.position=ccp(3 * m_scaleX, 125 * m_scaleY);
        [arrowCount setScaleY:m_scaleY];
        [arrowCount setScaleX:m_scaleX];
        [gameUICMC addChild:arrowCount];
        
        //Score text
        scoreText=[CCLabelBMFont labelWithString:@"Score:0" fntFile:@"CooperBlack.fnt"];
        scoreText.anchorPoint=ccp(0,0);
        scoreText.position=ccp(3 * m_scaleX, -3 * m_scaleY);
        [scoreText setScaleX:m_scaleX];
        [scoreText setScaleY:m_scaleY];
        [gameUICMC addChild:scoreText];
        
        //High Score
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
        highScoreText = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"High Score:%d", highScore] fntFile:@"CooperBlack.fnt"];
        highScoreText.anchorPoint=ccp(0.5f,1);
        highScoreText.position=ccp(ws.width / 2, ws.height);
        [highScoreText setScaleY:m_scaleY];
        [highScoreText setScaleX:m_scaleX];
        [gameUICMC addChild:highScoreText];
        
        //Time text
        timeText=[CCLabelBMFont labelWithString:@"Time:60" fntFile:@"CooperBlack.fnt"];
        timeText.anchorPoint=ccp(0,1);
        timeText.position=ccp(3 * m_scaleX,ws.height);
        [timeText setScaleX:m_scaleX];
        [timeText setScaleY:m_scaleY];
//        [gameUICMC addChild:timeText];
        
        //Gold Coin
        CCSprite* goldCoin = [CCSprite spriteWithSpriteFrameName:@"FruitCoin.png"];
        [goldCoin setScale:0.4f];
        [goldCoin setPosition:ccp(240 * m_scaleX, 20 * m_scaleY)];
        [gameUICMC addChild:goldCoin];
        
        lbl_coinScore=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", app->m_coinScore] fntFile:@"CooperBlack.fnt"];
        [lbl_coinScore setAnchorPoint:CGPointMake(0, 0.5f)];
        [lbl_coinScore setPosition:ccp(270 * m_scaleX, 20 * m_scaleY)];
        [lbl_coinScore setScaleY:m_scaleY];
        [lbl_coinScore setScaleX:m_scaleX];
        [self addChild:lbl_coinScore];
        
        // Arrow Pack
        arrowPack = [CCSprite spriteWithSpriteFrameName:@"arrow_pack.png"];
        [arrowPack setAnchorPoint:CGPointMake(0, 0.5f)];
        [arrowPack setPosition:ccp(20 * m_scaleX, 160 * m_scaleY)];
        [gameUICMC addChild:arrowPack];
        [arrowPack setVisible:FALSE];
        
        lbl_arrowPackCount=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"X%d", app->m_arrowPackCount] fntFile:@"CooperBlack.fnt"];
        [lbl_arrowPackCount setAnchorPoint:ccp(0, 0.5f)];
        [lbl_arrowPackCount setPosition:ccp(50 * m_scaleX, 160 * m_scaleY)];
        [lbl_arrowPackCount setScale:0.8f];
        [gameUICMC addChild:lbl_arrowPackCount];
        [lbl_arrowPackCount setVisible:FALSE];
        
        //Reload Label
        lbl_reload = [CCLabelBMFont labelWithString:@"Reload" fntFile:@"CooperBlack.fnt"];
        [lbl_reload setPosition:ccp(ws.width / 2, ws.height / 2)];
        [lbl_reload setVisible:FALSE];
        [lbl_reload setScaleX:m_scaleX];
        [lbl_reload setScaleY:m_scaleY];
        [self addChild:lbl_reload];
	}
	return self;
}

-(void)dealloc
{
    [objArr release];
    [self unscheduleAllSelectors];
    [super dealloc];
}

-(void)initLevel
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    gamePaused=YES;
    theTime=0;
    currentLevel=1;
    currentArrowIsDead=YES;
    score = 0;
    taskObjNum=15;
    limitTime=65;
    currentObjNum=0;
    m_arrowCount = 10;
    m_baseTime = -1;
    
    CCSprite* btnSprite = [CCSprite spriteWithSpriteFrameName:@"btn_reload.png"];
    CCSprite* btnSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_reload.png"];
    
    CCMenuItemSprite* btnReload = [CCMenuItemSprite itemWithNormalSprite:btnSprite selectedSprite:btnSprite1];
    [btnReload setTarget:self selector:@selector(Reload)];
    
    CCMenu* menu = nil;
    if (app->m_playMode == SinglePlay)
    {
        CCSprite* btnPauseSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_pause.png"];
        [btnPauseSprite1 setOpacity:180];
        CCSprite* btnPauseSprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_pause.png"];
        
        CCMenuItemSprite* btnPause = [CCMenuItemSprite itemWithNormalSprite:btnPauseSprite1 selectedSprite:btnPauseSprite2];
        [btnPause setTarget:self selector:@selector(OnPause)];
        [btnPause setPosition:ccp(60 * m_scaleX, 0)];
        menu = [CCMenu menuWithItems:btnReload, btnPause, nil];
    }
    else
        menu = [CCMenu menuWithItems:btnReload, nil];
    
    [menu setPosition:ccp(ws.width - (80 * m_scaleX), 300 * m_scaleY)];
    [self addChild:menu];
    
    if (app->m_arrowPackCount > 0)
    {
        [arrowPack setVisible:TRUE];
        [lbl_arrowPackCount setVisible:TRUE];
    }
    
    if (app->m_playMode == MultiPlayWithNextPeer)
        [timeText setVisible:FALSE];
}

-(void)onEnterTransitionDidFinish
{
    m_isReady = true;
    m_isStarted = false;
}

-(void)StartGame
{
    m_isReady = true;
    m_isStarted = true;
    [self initLevel];
    [self unscheduleAllSelectors];
    [self schedule:@selector(loop)];
    [self showLevelInfo:@"Ready" level:currentLevel InfoType:ShowLevelState gameOverAndPassScore:-1];
}

-(void)RestartGame
{
    limitTime += 5;
    [self NextLevel];
}

-(void)NextLevel
{
    int lmtTm = limitTime - 5;
    if (lmtTm < 20)
        lmtTm = 20;
//    [timeText setString:[NSString stringWithFormat:@"Time:%d", lmtTm]];
    [self unscheduleAllSelectors];
    [self schedule:@selector(loop)];
    [self showLevelInfo:@"Ready" level:currentLevel InfoType:ShowLevelState gameOverAndPassScore:-1];
}

//touch
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint loc=[touch locationInView:[touch view]];
    loc=[[CCDirector sharedDirector]convertToGL:loc];
    CGPoint point=CGPointMake(loc.x, loc.y);

    if (!gamePaused && bowArrow.shootAble && m_arrowCount > 0 && arrowsArr.count == 0)
    {
        bowArrow.rotation=atan2f(bowArrow.position.x-point.x,bowArrow.position.y-point.y)*180/M_PI +90;
        [bowArrow playShootMovie];
        [self shoot];
        m_arrowCount--;
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (app->m_arrowPackCount > 0 && m_arrowCount == 0)
        {
            m_arrowCount = 30;
            app->m_arrowPackCount--;
            [lbl_arrowPackCount setString:[NSString stringWithFormat:@"X%d", app->m_arrowPackCount]];
            if (app->m_arrowPackCount == 0)
            {
                [arrowPack setVisible:FALSE];
                [lbl_arrowPackCount setVisible:FALSE];
            }
        }
        [arrowCount setString:[NSString stringWithFormat:@"Arrows:%d", m_arrowCount]];
    }
}

//get UIImage from CCSprite
- (UIImage *) renderUIImageFromSprite :(CCSprite *)sprite {
    
    int tx = sprite.contentSize.width;
    int ty = sprite.contentSize.height;
    
    CCRenderTexture *renderer	= [CCRenderTexture renderTextureWithWidth:tx height:ty];
    CGPoint oriPoint=sprite.anchorPoint;
    sprite.anchorPoint	= CGPointZero;
    
    [renderer begin];
    [sprite visit];
    [renderer end];
    sprite.anchorPoint=oriPoint;
    return [renderer getUIImage];
}

//update time text
-(void)updateTime
{
    if (gamePaused)
        return;
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    theTime--;
//    [timeText setString:[NSString stringWithFormat:@"Time:%i",theTime]];
    if (m_baseTime >= 0)
        m_baseTime++;
    
//    if(theTime==0)
//    {
//        if (app->m_playMode != MultiPlayWithNextPeer)
//        {
//            [self unschedule:@selector(updateTime)];
//            gamePaused=YES;
//            [self showLevelInfo:@"Time's Up" level:0 InfoType:GameOverState gameOverAndPassScore:score];
//        }
//    }
//    else
        if (m_arrowCount == 0 && app->m_arrowPackCount == 0 && m_baseTime == -1)
    {
        [self showLevelInfo:@"There is no arrow" level:0 InfoType:NoArrow gameOverAndPassScore:score];
        m_baseTime = 0;
    }
    
    if (m_baseTime > 2)
    {
        if (m_scoreForLevel < 1200)
            m_isOver = true;
        m_baseTime = -1;
        [lbl_reload setVisible:FALSE];
        [self CompletedLevel];
    }
}

-(int)getFruitId
{
    int newId = 0;
    for (int i = 0; i < 3; i++)
    {
        BOOL isExist = false;
        for(TargetObject* fruit in objArr)
        {
            if (fruit->m_idx == i)
            {
                isExist = true;
                break;
            }
        }
        if (!isExist)
        {
            newId = i;
            break;
        }
    }
    return newId;
}

//create target objects
-(void)catapultObject
{    
    TargetObject *tar=[[[TargetObject alloc] initWithIndex:[self getFruitId]] autorelease];
    tar.scale=0.6;
    tar.position=ccp(ws.width-100, -20);
    [targetsCMC addChild:tar];
    [objArr addObject:tar];
}

-(void)catapultObjectFromServer:(int)idx type:(int)typ
{
    TargetObject *tar=[[[TargetObject alloc] initFromServer:idx type:typ] autorelease];
    tar.scale=0.6;
    tar.position=ccp(ws.width-100, -20);
    [targetsCMC addChild:tar];
    [objArr addObject:tar];
}

-(void)Explosion:(CGPoint)position
{
    CCParticleSystemQuad* particle = [[CCParticleSystemQuad alloc] initWithFile:@"FruitBurst.plist"];
    particle.autoRemoveOnFinish = YES;
    particle.duration = 0.01f;
    particle.position = position;
    [particle setScaleX:m_scaleX];
    [particle setScaleY:m_scaleY];
    [self addChild:particle];
}

//The main loop
-(void)loop
{
    for (int i=0; i<[arrowsArr count]; i++)
    {
        Arrow *ar=((Arrow *)[arrowsArr objectAtIndex:i]);
        float px=cosf(-ar.rotation/180*M_PI)*15 * m_scaleX;
        float py=sinf(-ar.rotation/180*M_PI)*15 * m_scaleY;
        ar.position=ccp(ar.position.x+px,ar.position.y+py);
        if (ar.position.x > ws.width || ar.position.y > ws.height || ar.position.y < -10 || ar.position.x < -10)
        {
            [arrowsArr removeObjectAtIndex:i];
            [ar removeFromParentAndCleanup:YES];
            i--;
        }
    }
    if (!gamePaused)
    {
        @synchronized(objArr)
        {
            for (int j=0; j<[objArr count]; j++) {
                TargetObject *tar=((TargetObject *)[objArr objectAtIndex:j]);
                for (int i=0; i<[arrowsArr count]; i++)
                {
                    Arrow *ar=((Arrow *)[arrowsArr objectAtIndex:i]);
                    CGRect aRect=CGRectMake(ar.position.x, ar.position.y, 1, 1);
                    CGRect birdRect=CGRectMake(tar.position.x- (15 * m_scaleX) , tar.position.y- (15 * m_scaleY), 30 * m_scaleX, 30 * m_scaleY);
                    if(CGRectIntersectsRect(aRect, birdRect))
                    {
                        if (!tar.isDead)
                        {
                            AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                            if (app->m_playMode == MultiPlayWithGameCenter)
                                [app->m_gameCenterManager SendExplose:tar->m_idx];
                            if (ar->m_ownerNum == 1)
                            {
                                if (tar->m_isGold)
                                {
                                    app->m_coinScore += arc4random() % 11;
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:app->m_coinScore] forKey:@"GoldCoin"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                else
                                {
                                    score+= scoreList[tar->m_fruitType];
                                    m_scoreForLevel += scoreList[tar->m_fruitType];
                                }
                                
                                if (score > highScore)
                                    highScore = score;
                                [self ChangeStoreInfo];
                            }
                            
                            tar.isDead=YES;
                            currentObjNum++;
                            
                            [self Explosion:tar.position];
                            [targetsCMC removeChild:tar cleanup:YES];
                            [objArr removeObjectAtIndex:j];
                            j--;
                            
                            [[SimpleAudioEngine sharedEngine] playEffect:@"hit.mp3"];
                            
//                            if (app->m_playMode != MultiPlayWithNextPeer)
//                            if (app->m_playMode == SinglePlay)
//                            {
//                                if (currentObjNum==taskObjNum) {
//                                    [self showLevelInfo:[NSString stringWithFormat:@"Level %i Complete", currentLevel] level:currentLevel InfoType:NextLevelState gameOverAndPassScore:-1];
//                                    currentObjNum=0;
//                                    gamePaused=YES;
//                                    [self unschedule:@selector(updateTime)];
//                                }
//                            }
                            if ((app->m_playMode == MultiPlayWithGameCenter && app->m_gameCenterManager.isServer) ||
                                app->m_playMode == MultiPlayWithNextPeer ||
                                app->m_playMode == SinglePlay)
                                [self catapultObject];
                            break;
                        }
                    }
                }
            }
        }
    }
}

-(void)RemoveFruit:(int)index
{
    @synchronized(objArr)
    {
        TargetObject* tar = nil;
        for(TargetObject* itm in objArr)
        {
            if (itm->m_idx == index)
            {
                tar = itm;
                break;
            }
        }
        [self Explosion:tar.position];
        [targetsCMC removeChild:tar cleanup:YES];
        [objArr removeObject:tar];
        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.mp3"];
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (app->m_playMode == MultiPlayWithGameCenter && app->m_gameCenterManager.isServer)
            [self catapultObject];
    }
}

//show level info 
-(void) showLevelInfo:(NSString *)infoStr level:(int)_level InfoType:(enum GameState)type gameOverAndPassScore:(int)passScore
{    
    currentObjNum=0;

    [infoText setVisible:YES];
    [infoText setScale:0];
    [infoText setString:infoStr];
    id scaleTo1=[CCScaleTo actionWithDuration:0.6 scale:1.2f * m_scaleY];
    id scaleTo0=[CCScaleTo actionWithDuration:0.6 scale:0];
    id delay=[CCDelayTime actionWithDuration:0.8];
    id cccfND;
    BOOL  hasSelector = true;
    switch (type) {
        case GameOverState:
        {
            if (m_scoreForLevel < 1200)
                m_isOver = true;
            cccfND=[CCCallFuncND actionWithTarget:self selector:@selector(CompletedLevel) data:nil];
            break;
        }
        case ShowLevelState:
        {
            cccfND=[CCCallFuncND actionWithTarget:self selector:@selector(ShowLevel:data:) data:(void *)_level];
            break;
        }
        case StartNewLevelState:
        {
            cccfND=[CCCallFuncND actionWithTarget:self selector:@selector(StartNewLevel:data:) data:(void *)_level];
            break;
        }
        case NextLevelState:
        {
            if (m_scoreForLevel < 1200)
                m_isOver = true;
            cccfND=[CCCallFuncND actionWithTarget:self selector:@selector(CompletedLevel) data:nil];
            break;
        }
        case NoArrow:
        {
            cccfND=[CCCallFuncND actionWithTarget:self selector:@selector(NoArrow) data:nil];
            break;
        }
        default:
        {
            hasSelector = false;
            break;
        }
    }
        
    id seq = nil;
    if (hasSelector)
        seq = [CCSequence actions:[CCEaseBackOut actionWithAction:scaleTo1],delay,[CCEaseExponentialIn actionWithAction:scaleTo0],cccfND,nil];
    else
        seq = [CCSequence actions:[CCEaseBackOut actionWithAction:scaleTo1],delay,[CCEaseExponentialIn actionWithAction:scaleTo0], nil];
    [infoText stopAllActions];
    [infoText runAction:seq];
    [[SimpleAudioEngine sharedEngine]playEffect:@"snd_info.wav"];
}

-(void)NoArrow
{
    m_baseTime = 0;
    [lbl_reload setVisible:TRUE];
}

//show level info complete
-(void) ShowLevel:(id)sender data:(int)data
{
    [self showLevelInfo:[NSString stringWithFormat:@"LEVEL %i",data] level:data InfoType:StartNewLevelState gameOverAndPassScore:-1];
}

//second time ,start new level
-(void) StartNewLevel:(id)sender data:(int)data{
    infoText.visible=NO;
    gamePaused=NO;
    if (limitTime > 20)
        limitTime -= 5;
    theTime = limitTime;

    [self clear];
    [self unschedule:@selector(updateTime)];
    [self schedule:@selector(updateTime) interval:1];
//    [timeText setString:[NSString stringWithFormat:@"Time:%i",limitTime]];
    m_scoreForLevel = 0;
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app->m_playMode == SinglePlay || app->m_playMode == MultiPlayWithNextPeer)
        for (int i=0; i<3; i++)
            [self catapultObject];
    else
    {
        if (app->m_gameCenterManager.isServer)
            for (int i=0; i<3; i++)
                [self catapultObject];
    }

    m_arrowCount = 30;
    [arrowCount setString:[NSString stringWithFormat:@"Arrows:%d", m_arrowCount]];
}

-(void)MultiPlayGameOver:(int)opponentScore
{
    GameOver* gmOver = [[[GameOver alloc] initWithScore:score opponentScore:opponentScore] autorelease];
    [[SimpleAudioEngine sharedEngine]playEffect:@"gameover.wav"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScore] forKey:@"HighScore"];
    [NSUserDefaults resetStandardUserDefaults];
    [[CCDirector sharedDirector] replaceScene:(CCScene*)gmOver];
}

//clear arrows and targets
-(void)clear{
    [objArr removeAllObjects];
    [targetsCMC removeAllChildrenWithCleanup:YES];
}

//shoot an arrow 
-(void)shoot{
    Arrow *newArrow=[[[Arrow alloc]init] autorelease];
    newArrow->m_ownerNum = 1;
    currentArrowIsDead=NO;
    newArrow.scale=bowArrow.scale;
    newArrow.anchorPoint=ccp(1,0.5);
    newArrow.rotation=bowArrow.rotation;
    float px=cosf(-newArrow.rotation/180*M_PI)*70;
    float py=sinf(-newArrow.rotation/180*M_PI)*70;
    newArrow.position=ccp(bowArrow.position.x+px ,bowArrow.position.y+py);
    [arrowsArr addObject:newArrow];
    [self addChild:newArrow];
}

-(void)shootByOpponent:(float)angle
{
    Arrow *newArrow=[[[Arrow alloc]init] autorelease];
    newArrow->m_ownerNum = 2;
    newArrow.scale=bowArrow.scale;
    newArrow.anchorPoint=ccp(1,0.5);
    newArrow.rotation = angle;
    float px=cosf(-newArrow.rotation/180*M_PI)*70;
    float py=sinf(-newArrow.rotation/180*M_PI)*70;
    newArrow.position=ccp(bowArrow.position.x+px ,bowArrow.position.y+py);

    [newArrow setColor:ccc3(255, 125, 100)];
    [arrowsArr addObject:newArrow];
    [self addChild:newArrow];
}

-(void)OnPause
{
    if (gamePaused)
        return;
    gamePaused = YES;
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"gameover.wav"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScore] forKey:@"HighScore"];
    [NSUserDefaults resetStandardUserDefaults];
    
    ws=[[CCDirector sharedDirector]winSize];
    
    CCSprite* background = [CCSprite spriteWithFile:@"gradient_background.png"];
    [background setPosition:ccp(ws.width / 2, ws.height / 2)];
    
    CCSprite* lbl_gamepaused = [CCSprite spriteWithSpriteFrameName:@"lbl_game_paused.png"];
    [lbl_gamepaused setPosition:ccp(ws.width / 2, 256 * m_scaleY)];
    
    CCSprite* btnResumeSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_resume.png"];
    CCSprite* btnResumeSprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_resume.png"];
    CCMenuItem* btnResume = [CCMenuItemSprite itemWithNormalSprite:btnResumeSprite1 selectedSprite:btnResumeSprite2 target:self selector:@selector(OnResume)];
    [btnResume setPosition:ccp(0, 175 * m_scaleY)];
    
    CCSprite* btnMainMenuSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_main_menu.png"];
    CCSprite* btnMainMenuSprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_main_menu.png"];
    CCMenuItem* btnMainMenu = [CCMenuItemSprite itemWithNormalSprite:btnMainMenuSprite1 selectedSprite:btnMainMenuSprite2 target:self selector:@selector(OnMainMenu)];
    [btnMainMenu setPosition:ccp(0, 130 * m_scaleY)];
    
    CCSprite* btnStoreSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_store.png"];
    CCSprite* btnStoreSprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_store.png"];
    CCMenuItem* btnStore = [CCMenuItemSprite itemWithNormalSprite:btnStoreSprite1 selectedSprite:btnStoreSprite2 target:self selector:@selector(OnStore)];
    [btnStore setPosition:ccp(0, 85 * m_scaleY)];
    
    CCSprite* btnReplaySprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_replay.png"];
    CCSprite* btnReplaySprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_replay.png"];
    CCMenuItem* btnReplay = [CCMenuItemSprite itemWithNormalSprite:btnReplaySprite1 selectedSprite:btnReplaySprite2 target:self selector:@selector(OnReplay)];
    [btnReplay setPosition:ccp(0, 40 * m_scaleY)];
    
    CCMenu* menu = [CCMenu menuWithItems:btnResume, btnMainMenu, btnStore, btnReplay, nil];
    [menu setPosition:ccp(ws.width / 2, 0)];
    
    m_pauseScreen = [[[CCSprite alloc] init] autorelease];
    [m_pauseScreen addChild:background];
    [m_pauseScreen addChild:menu];
    [m_pauseScreen addChild:lbl_gamepaused];
    
    [self addChild:m_pauseScreen];
}

-(void)CompletedLevel
{
    gamePaused = YES;
    [self clear];
    ws=[[CCDirector sharedDirector]winSize];
    
    CCSprite* background = [CCSprite spriteWithFile:@"gradient_background.png"];
    [background setPosition:ccp(ws.width / 2, ws.height / 2)];
    
    NSString* strLabelName = @"";
    if (m_isOver)
        strLabelName = @"lbl_level_incomplete.png";
    else
        strLabelName = @"lbl_level_completed.png";
    
    CCSprite* lbl_level_completed = [CCSprite spriteWithSpriteFrameName:strLabelName];
    [lbl_level_completed setPosition:ccp(ws.width / 2, 256 * m_scaleY)];
    
    CCSprite* btnReplaySprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_replay.png"];
    CCSprite* btnReplaySprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_replay.png"];
    CCMenuItem* btnReplay = [CCMenuItemSprite itemWithNormalSprite:btnReplaySprite1 selectedSprite:btnReplaySprite2 target:self selector:@selector(OnReplay)];
    if (m_isOver)
        [btnReplay setPosition:ccp(0, 85 * m_scaleY)];
    else
        [btnReplay setPosition:ccp(-116 * m_scaleX, 85 * m_scaleY)];
    
    CCSprite* btnNextLevelSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_next_level.png"];
    CCSprite* btnNextLevelSprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_next_level.png"];
    CCMenuItem* btnNextLevel = [CCMenuItemSprite itemWithNormalSprite:btnNextLevelSprite1 selectedSprite:btnNextLevelSprite2 target:self selector:@selector(OnNextLevel)];
    [btnNextLevel setPosition:ccp(116 * m_scaleX, 85 * m_scaleY)];
    if (m_isOver)
        [btnNextLevel setVisible:FALSE];
        
    CCSprite* btnMainMenuSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_main_menu.png"];
    CCSprite* btnMainMenuSprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_main_menu.png"];
    CCMenuItem* btnMainMenu = [CCMenuItemSprite itemWithNormalSprite:btnMainMenuSprite1 selectedSprite:btnMainMenuSprite2 target:self selector:@selector(OnMainMenu)];
    [btnMainMenu setPosition:ccp(-116 * m_scaleX, 40 * m_scaleY)];
    
    CCSprite* btnStoreSprite1 = [CCSprite spriteWithSpriteFrameName:@"btn_store.png"];
    CCSprite* btnStoreSprite2 = [CCSprite spriteWithSpriteFrameName:@"btn_store.png"];
    CCMenuItem* btnStore = [CCMenuItemSprite itemWithNormalSprite:btnStoreSprite1 selectedSprite:btnStoreSprite2 target:self selector:@selector(OnStore)];
    [btnStore setPosition:ccp(116 * m_scaleX, 40 * m_scaleY)];
    
    CCMenu* menu = [CCMenu menuWithItems:btnNextLevel, btnMainMenu, btnStore, btnReplay, nil];
    [menu setPosition:ccp(ws.width / 2, 0)];
    
    m_completedLevelScreen = [[[CCSprite alloc] init] autorelease];
    [m_completedLevelScreen addChild:background];
    [m_completedLevelScreen addChild:lbl_level_completed];
    [m_completedLevelScreen addChild:menu];
    
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (m_scoreForLevel > 1200)
    {
        CCSprite* star = [CCSprite spriteWithSpriteFrameName:@"star.png"];
        [m_completedLevelScreen addChild:star];
        [star setPosition:ccp(ws.width / 2 - (81 * m_scaleX), 202 * m_scaleY)];
        app->m_coinScore += 1;
    }
    if (m_scoreForLevel > 1500)
    {
        CCSprite* secondStar = [CCSprite spriteWithSpriteFrameName:@"star.png"];
        [secondStar setPosition:ccp(ws.width / 2, 202 * m_scaleY)];
        [m_completedLevelScreen addChild:secondStar];
        app->m_coinScore += 5;
    }
    if (m_scoreForLevel > 2000)
    {
        CCSprite* thirdStar = [CCSprite spriteWithSpriteFrameName:@"star.png"];
        [thirdStar setPosition:ccp(ws.width / 2 + (81 * m_scaleX), 202 * m_scaleY)];
        [m_completedLevelScreen addChild:thirdStar];
        app->m_coinScore += 10;
    }
    
    CCLabelBMFont* lbl_score =[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Score:%d", m_scoreForLevel] fntFile:@"CooperBlack.fnt"];
    [lbl_score setPosition:ccp(ws.width / 2, 140 * m_scaleY)];
    [lbl_score setScaleX:1.5f * m_scaleX];
    [lbl_score setScaleY:1.5f * m_scaleY];
    [m_completedLevelScreen addChild:lbl_score];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:app->m_coinScore] forKey:@"GoldCoin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self addChild:m_completedLevelScreen];
    [self ChangeStoreInfo];
    m_isOver = false;
}

-(void)OnResume
{
    if (m_pauseScreen != nil)
    {
        [m_pauseScreen removeFromParentAndCleanup:TRUE];
        m_pauseScreen = nil;
    }
    gamePaused = NO;
}

-(void)OnMainMenu
{
    if (m_pauseScreen != nil)
    {
        [m_pauseScreen removeFromParentAndCleanup:TRUE];
        m_pauseScreen = nil;
    }
    if (m_completedLevelScreen != nil)
    {
        [m_completedLevelScreen removeFromParentAndCleanup:TRUE];
        m_completedLevelScreen = nil;
    }
    gamePaused = NO;
    [[CCDirector sharedDirector] replaceScene:[GameIntro scene]];
}

-(void)OnStore
{
    [self addChild:[[[StoreScreen alloc] init] autorelease]];
}

-(void)OnReplay
{
    if (m_pauseScreen != nil)
    {
        [m_pauseScreen removeFromParentAndCleanup:TRUE];
        m_pauseScreen = nil;
    }
    if (m_completedLevelScreen != nil)
    {
        [m_completedLevelScreen removeFromParentAndCleanup:TRUE];
        m_completedLevelScreen = nil;
    }
    score = 0;
    [self ChangeStoreInfo];
    [lbl_reload setVisible:FALSE];
    [self clear];
    [self RestartGame];
}

-(void)OnNextLevel
{
    currentLevel++;
    if (m_completedLevelScreen != nil)
    {
        [m_completedLevelScreen removeFromParentAndCleanup:TRUE];
        m_completedLevelScreen = nil;
    }
    gamePaused = NO;
    [self clear];
    [self NextLevel];
}

-(void)Reload
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app->m_coinScore >= 500)
    {
        app->m_coinScore -= 500;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:app->m_coinScore] forKey:@"GoldCoin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        app->m_arrowPackCount += 1;
        m_baseTime = -1;
        [lbl_reload setVisible:FALSE];
    }
    [self ChangeStoreInfo];
}

-(void)ChangeStoreInfo
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [lbl_arrowPackCount setString:[NSString stringWithFormat:@"X%d", app->m_arrowPackCount]];
    [lbl_coinScore setString:[NSString stringWithFormat:@"%d", app->m_coinScore]];
    if (app->m_arrowPackCount > 0)
    {
        [arrowPack setVisible:TRUE];
        [lbl_arrowPackCount setVisible:TRUE];
        if (m_arrowCount == 0)
        {
            m_arrowCount = 30;
            app->m_arrowPackCount--;
            [lbl_arrowPackCount setString:[NSString stringWithFormat:@"X%d", app->m_arrowPackCount]];
            if (app->m_arrowPackCount == 0)
            {
                [arrowPack setVisible:FALSE];
                [lbl_arrowPackCount setVisible:FALSE];
            }
        }
    }
    else
    {
        [arrowPack setVisible:FALSE];
        [lbl_arrowPackCount setVisible:FALSE];
    }

    [arrowCount setString:[NSString stringWithFormat:@"Arrows:%d", m_arrowCount]];
    [scoreText setString:[NSString stringWithFormat:@"Score:%i",score]];
    [highScoreText setString:[NSString stringWithFormat:@"High Score:%d", highScore]];
}
#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}

@end
