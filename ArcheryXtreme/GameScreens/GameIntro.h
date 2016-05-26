//
//  GameIntro.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
@interface GameIntro : CCLayer{
    CCSprite *background,*bunchMC;
    float   m_scaleX;
    float   m_scaleY;
  
}
+(NSString *)getMoreAppsURL;

+(NSString *)getMyWebsiteURL;

+(CCScene *) scene;
-(void)playButtonClicked;
-(void)myWebsiteButtonClicked;
-(void)moreAppsButtonClicked;
@property(nonatomic,retain) CCSprite *background,*bunchMC;
 
@end
