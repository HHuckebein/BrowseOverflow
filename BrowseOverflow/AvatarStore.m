//
//  AvatarStore.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "AvatarStore.h"

@interface AvatarStore()
@property (nonatomic, strong) NSCache *dataCache;
@property (nonatomic, strong) NSMutableDictionary *communicators;
@end

@implementation AvatarStore


#pragma mark - GravatarCommunicatorDelegate

- (void)communicatorReceivedData:(NSData *)data forURL:(NSURL *)url
{
    
}

- (void)communicatorGotErrorForURL:(NSURL *)url
{
    
}

@end
