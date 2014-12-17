//
//  GravatarCommunicator.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarCommunicatorDelegate.h"

@interface GravatarCommunicator : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, weak  ) id <GravatarCommunicatorDelegate> delegate;
@property (nonatomic, strong) NSURL                             *url;
@property (nonatomic, strong) NSMutableData                     *receivedData;
@property (nonatomic, weak  ) NSURLConnection                   *connection;

- (void)fetchDataForURL:(NSURL *)location;
- (void)cancel;

@end

