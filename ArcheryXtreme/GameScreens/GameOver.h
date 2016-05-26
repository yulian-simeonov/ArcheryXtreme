//
//  GameOver.h
//  BowHunting
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCLayer.h"
#import "GameMain.h"
#import "cocos2d.h"
@interface GameOver : CCSprite
{
    
}
-(id) initWithScore:(int)score opponentScore:(int)sndScore;
@end
