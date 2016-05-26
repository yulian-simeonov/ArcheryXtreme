//
//  NextPeerManager.h
//  ArcheryXtreme
//
//  Created by ZhangBuSe on 1/31/13.
//  Copyright (c) 2013 Conception Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nextpeer/Nextpeer.h"
#import "JSMultiPlayerManager.h"

@interface NextPeerManager : NSObject<NextpeerDelegate, NPTournamentDelegate>

@property (nonatomic) BOOL isServer;
@end

