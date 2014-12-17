//
//  MockStackOverflowManagerDelegate.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "MockStackOverflowManagerDelegate.h"

@interface MockStackOverflowManagerDelegate()
@property (nonatomic, copy  ) NSError *fetchedError;
@property (nonatomic, strong) Question *bodyQuestion;
@property (nonatomic, strong) Question *successQuestion;
@property (nonatomic, strong) NSArray *fetchedQuestions;

@end

@implementation MockStackOverflowManagerDelegate

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
    self.bodyQuestion = question;   
}

- (void)didReceiveQuestions:(NSArray *)questions {
    self.fetchedQuestions = questions;
}

- (void)retrievingAnswersFailedWithError:(NSError *)error {
    self.fetchedError = error;
}

- (void)answersReceivedForQuestion:(Question *)question {
    self.successQuestion = question;
}

@end
