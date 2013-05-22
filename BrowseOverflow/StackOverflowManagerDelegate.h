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

- (void)didReceiveQuestions: (NSArray *)questions;
- (void)fetchingQuestionsFailedWithError:(NSError *)error;

- (void)bodyReceivedForQuestion:(Question *)question;
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error;

- (void)answersReceivedForQuestion: (Question *)question;
- (void)retrievingAnswersFailedWithError: (NSError *)error;

@end
