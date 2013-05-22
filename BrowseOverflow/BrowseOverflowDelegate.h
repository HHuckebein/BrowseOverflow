//
//  BrowseOverflowProtocol.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 22.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AvatarStore, StackOverflowManager;
@protocol BrowseOverflowDelegate <NSObject>
@required
- (AvatarStore *)avatarStore;
- (StackOverflowManager *)manager;
@end
