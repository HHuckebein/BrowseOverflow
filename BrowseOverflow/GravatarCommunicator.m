//
//  GravatarCommunicator.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "GravatarCommunicator.h"

@implementation GravatarCommunicator

- (void)fetchDataForURL:(NSURL *)location {
    self.url = location;
    NSURLRequest *request = [NSURLRequest requestWithURL: location];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnection Delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_delegate communicatorReceivedData:[self.receivedData copy] forURL:self.url];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receivedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_delegate communicatorGotErrorForURL:self.url];
}

- (void)cancel
{
    [self.connection cancel];
    _connection = nil;
    _url = nil;
    _receivedData = nil;
}

@end
