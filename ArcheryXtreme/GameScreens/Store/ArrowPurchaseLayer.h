//
//  ArrowPurchaseLayer.h
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/23/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface ArrowPurchaseLayer : CCLayer
{
    float   m_scaleX;
    float   m_scaleY;
}

@property (nonatomic, retain) id delegate;
@end
