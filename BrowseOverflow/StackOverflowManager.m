//
//  StackOverflowManager.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "StackOverflowManager.h"
#import "StackOverflowCommunicator.h"
#import "Topic.h"
#import "QuestionBuilder.h"
#import "Question.h"
#import "AnswerBuilder.h"

NSString *const StackOverflowManagerError = @"StackOverflowManagerError";

@interface StackOverflowManager()
@property (nonatomic, strong) Question *questionNeedingBody;
@property (nonatomic, strong) Question *questionToFill;
@end

@implementation StackOverflowManager

#pragma mark - Set Delegate

- (void)setDelegate:(id<StackOverflowManagerDelegate>)delegate
{
    if (delegate && ![delegate conformsToProtocol:@protocol(StackOverflowManagerDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Delegate does not conform to StackOverflowManagerDelegate protocol"
                               userInfo:nil] raise];
    }
    _delegate = delegate;
}

#pragma mark - Question

- (void)fetchQuestionsOnTopic:(Topic *)topic
{
    [self.communicator searchForQuestionsWithTag:topic.tag];
}

#pragma mark - Question Body

- (void)fetchBodyForQuestion:(Question *)question
{
    self.questionNeedingBody = question;
    [self.communicator downloadInformationForQuestionWithID:self.questionNeedingBody.questionID];
}

#pragma mark - Answers

- (void)fetchAnswersForQuestion:(Question *)question {
    self.questionToFill = question;
    [self.communicator downloadAnswersToQuestionWithID: question.questionID];
}

#pragma mark - StackOverflowCommunicatorDelegate
#pragma mark Question

- (void)receivedQuestionsJSON:(NSString *)objectNotation
{
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
    if (!questions) {
        [self tellDelegateAboutQuestionSearchError:error];
    }
    else {
        [_delegate didReceiveQuestions:questions];
    }
}

- (void)searchingForQuestionsFailedWithError:(NSError *)error
{
    [self tellDelegateAboutQuestionSearchError:error];
}

#pragma mark Question Body

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation
{
    [self.questionNeedingBody fillInDetailsFromJSON:objectNotation];
    [_delegate bodyReceivedForQuestion:self.questionNeedingBody];
    self.questionNeedingBody = nil;
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = nil;
    if (error) {
        errorInfo = @{NSUnderlyingErrorKey : error};
    }
    
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorQuestionBodyFetchCode
                                               userInfo:errorInfo];
    
    [_delegate fetchingQuestionBodyFailedWithError:reportableError];
    
    self.questionNeedingBody = nil;
}

#pragma mark Answers

- (void)receivedAnswerListJSON: (NSString *)objectNotation
{
    NSError *error = nil;
    
    if ([self.answerBuilder addAnswersToQuestion:self.questionToFill fromJSON:objectNotation error:&error]) {
        [_delegate answersReceivedForQuestion:self.questionToFill];
        self.questionToFill = nil;
    }
    else {
        [self fetchingAnswersFailedWithError:error];
    }
}

- (void)fetchingAnswersFailedWithError:(NSError *)error
{
    self.questionToFill = nil;

    NSDictionary *userInfo = nil;
    if (error) {
        userInfo = @{NSUnderlyingErrorKey : error};
    }
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorAnswerFetchCode
                                               userInfo:userInfo];
    [_delegate retrievingAnswersFailedWithError: reportableError];
}

#pragma mark Helper

- (void)tellDelegateAboutQuestionSearchError:(NSError *)underlyingError
{
    NSDictionary *userInfo = nil;
    if (underlyingError) {
        userInfo = @{NSUnderlyingErrorKey : underlyingError};
    }

    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorQuestionSearch
                                               userInfo:userInfo];
    
    [_delegate fetchingQuestionsFailedWithError:reportableError];
}

@end
