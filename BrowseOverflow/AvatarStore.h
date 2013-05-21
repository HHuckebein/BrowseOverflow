//
//  AvatarStore.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarCommunicatorDelegate.h"

extern NSString *const AvatarStoreDidUpdateContentNotification;

@interface AvatarStore : NSObject <GravatarCommunicatorDelegate>

@property (nonatomic, strong, readonly) NSCache *dataCache;
@property (nonatomic, strong, readonly) NSData *defaultData;
@property (nonatomic, strong, readonly) NSMutableDictionary *communicators;

- (NSData *)dataForURL:(NSURL *)url;

@end
