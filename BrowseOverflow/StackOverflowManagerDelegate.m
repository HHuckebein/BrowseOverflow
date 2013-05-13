//
//  StackOverflowManagerDelegate.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "StackOverflowManagerDelegate.h"

@interface StackOverflowManagerDelegate()
@property (nonatomic, copy) NSError *fetchedError;
@end

@implementation StackOverflowManagerDelegate

- (void)fetchingQuestionsFailedWithError:(NSError *)error
{
    self.fetchedError = error;
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error
{
    self.fetchedError = error;
}

- (void)bodyReceivedForQuestion:(Question *)question
{
    
}

@end
