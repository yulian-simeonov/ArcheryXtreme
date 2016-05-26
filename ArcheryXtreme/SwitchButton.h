//
//  SwitchButton.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "CCMenuItem.h"
#import "CCMenu.h"
@interface SwitchButton : CCSprite{
    
    BOOL isOpen;
    
    CCMenuItem *playMI;
    
    CCMenu *playButton;
    
    CCMenuItem *playMI2;
    
    CCMenu *playButton2;
    ;
}
-(void) initWithImageStr:(NSString *) o1 O2:(NSString*)o2 O3:(NSString*)o3 O4:(NSString*)o4 Open:(BOOL) open;
-(void) btnClick;

@property(nonatomic,assign) BOOL isOpen;

@property(nonatomic,retain) CCMenuItem *playMI;
@property(nonatomic,retain) CCMenu *playButton;
@property(nonatomic,retain) CCMenuItem *playMI2;
@property(nonatomic,retain) CCMenu *playButton2;
 

@end
