//
//  AvatarStore.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "AvatarStore.h"
#import "GravatarCommunicator.h"

NSString *const AvatarStoreDidUpdateContentNotification = @"AvatarStoreDidUpdateContentNotification";

@interface AvatarStore()
@property (nonatomic, strong) NSCache *dataCache;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *communicators;
@property (nonatomic, strong) NSData *defaultData;
@end

@implementation AvatarStore

- (NSData *)dataForURL:(NSURL *)url
{
    if (nil == url) return nil;

    NSData *avatarData = [self.dataCache objectForKey:[url absoluteString]];
    if (!avatarData) {
        GravatarCommunicator *communicator = [[GravatarCommunicator alloc] init];
        [self.communicators setObject:communicator forKey:[url absoluteString]];
        communicator.delegate = self;
        [communicator fetchDataForURL:url];
    }
    return avatarData;
}

- (NSData *)defaultData
{
    if (nil == _defaultData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"JohnDoe" ofType:@"png"];
        _defaultData = [NSData dataWithContentsOfFile:path];
    }
    return _defaultData;
}

- (NSCache *)dataCache
{
    if (nil == _dataCache) {
        _dataCache = [[NSCache alloc] init];
    }
    return _dataCache;
}

- (NSMutableDictionary *)communicators
{
    if (nil == _communicators) {
        _communicators = [NSMutableDictionary dictionary];
    }
    return _communicators;
}

- (NSOperationQueue *)queue
{
    if (nil == _queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSNotificationCenter *)notificationCenter
{
    if (nil == _notificationCenter) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}

#pragma mark - GravatarCommunicatorDelegate

- (void)communicatorReceivedData:(NSData *)data forURL:(NSURL *)url
{
    [self.dataCache setObject:data forKey:[url absoluteString]];
    [self.communicators removeObjectForKey:[url absoluteString]];
    
    NSNotification *note = [NSNotification notificationWithName:AvatarStoreDidUpdateContentNotification object:self];
    [self.notificationCenter postNotification:note];
}

- (void)communicatorGotErrorForURL:(NSURL *)url
{
    NSString *key = [url absoluteString];
    
    [self.communicators removeObjectForKey:key];
    [self.dataCache removeObjectForKey:key];
}

@end
