//
//  Clouds.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCSprite.h"

@interface Clouds : CCSprite
{
    CCSprite *clip1,*clip2,*clip3,*clip4;
}
-(void)stop;
-(void)start;

@property(nonatomic ,retain) CCSprite *clip1,*clip2,*clip3,*clip4;

@end
