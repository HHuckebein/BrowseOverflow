//
//  AvatarStore+TestExtension.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "AvatarStore.h"

@interface AvatarStore (TestExtension)

- (void)setData:(NSData *)data forLocation:(NSString *)url;
- (BOOL)containsDataForLocation:(NSString *)url;
@end
