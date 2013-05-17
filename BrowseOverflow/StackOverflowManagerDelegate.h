//
//  StackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

@protocol StackOverflowManagerDelegate <NSObject>
@property (nonatomic, copy, readonly) NSError *fetchedError;

- (void)fetchingQuestionsFailedWithError:(NSError *)error;
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error;
- (void)bodyReceivedForQuestion:(Question *)question;

@end
