//
//  AvatarStore+TestExtension.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "AvatarStore+TestExtension.h"

@implementation AvatarStore (TestExtension)

- (void)setData:(NSData *)data forLocation:(NSString *)url
{
    [self.dataCache setObject:data forKey:url];
}

- (BOOL)containsDataForLocation:(NSString *)url
{
    return [self.dataCache objectForKey:url] ? YES : NO;
}

@end
