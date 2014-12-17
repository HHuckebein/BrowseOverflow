//
//  GravatarCommunicatorDelegate.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GravatarCommunicatorDelegate <NSObject>

- (void)communicatorReceivedData:(NSData *)data forURL:(NSURL *)url;
- (void)communicatorGotErrorForURL:(NSURL *)url;

@end
