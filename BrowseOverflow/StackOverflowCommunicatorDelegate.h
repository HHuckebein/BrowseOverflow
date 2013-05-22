//
//  StackOverflowCommunicatorDelegate.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StackOverflowCommunicatorDelegate <NSObject>

- (void)searchingForQuestionsFailedWithError:(NSError *)error;
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error;
- (void)fetchingAnswersFailedWithError:(NSError *)error;
- (void)receivedQuestionsJSON:(NSString *)objectNotation;
- (void)receivedAnswerListJSON:(NSString *)objectNotation;
- (void)receivedQuestionBodyJSON:(NSString *)objectNotation;

@end
