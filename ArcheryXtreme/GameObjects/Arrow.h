//
//  Arrow.h
//  ArcheryXtreme
//
//  Created by Conception Designs on 12-10-2013.
//  Copyright Conception Designs. All rights reserved.
//

#import "CCSprite.h"

@interface Arrow : CCSprite{
    CCSprite *mc;
@public
    int    m_ownerNum;
}
@property(nonatomic,retain) CCSprite *mc;
@end
