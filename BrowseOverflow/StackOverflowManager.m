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

NSString *const StackOverflowManagerError = @"StackOverflowManagerError";

@interface StackOverflowManager()
@property (nonatomic, strong) Question *questionNeedingBody;
@property (nonatomic, strong) Question *questionToFill;
@end

@implementation StackOverflowManager

- (void)setDelegate:(id<StackOverflowManagerDelegate>)delegate
{
    if (delegate && ![delegate conformsToProtocol:@protocol(StackOverflowManagerDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Delegate does not conform to StackOverflowManagerDelegate protocol"
                               userInfo:nil] raise];
    }
    _delegate = delegate;
}

- (void)fetchQuestionsOnTopic:(Topic *)topic
{
    [self.communicator searchForQuestionsWithTag:topic.tag];
}

- (void)searchingForQuestionsOnTopic:(Topic *)topic failedWithError:(NSError *)error
{
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorQuestionSearch
                                               userInfo:@{NSUnderlyingErrorKey : error}];
    
    [_delegate fetchingQuestionsFailedWithError:reportableError];
}

- (void)receivedQuestionJSON:(NSString *)objectNotation
{
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
    if (!questions) {
        NSDictionary *errorInfo = nil;
        if (error) {
            errorInfo = @{NSUnderlyingErrorKey : error};
        }
        NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                       code:StackOverflowManagerErrorQuestionSearch
                                                   userInfo:errorInfo];
        [_delegate fetchingQuestionsFailedWithError:reportableError];
    }
}

- (void)fetchBodyForQuestion:(Question *)question
{
    self.questionNeedingBody = question;
    [self.communicator downloadInformationForQuestionWithID:self.questionNeedingBody.questionID];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = nil;
    if (error) {
        errorInfo = @{NSUnderlyingErrorKey : error};
    }
    
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError code:StackOverflowManagerErrorQuestionBodyFetchCode userInfo:errorInfo];
    [_delegate fetchingQuestionBodyFailedWithError:reportableError];
    
    self.questionNeedingBody = nil;
}

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation
{
    [self.questionNeedingBody fillInDetailsFromJSON:objectNotation];
    [_delegate bodyReceivedForQuestion:self.questionNeedingBody];
    self.questionNeedingBody = nil;
}

- (void)receivedAnswerListJSON:(NSString *)objectNotation
{
    
}

- (void)searchingForQuestionsFailedWithError:(NSError *)error
{
    
}

- (void)fetchingAnswersFailedWithError:(NSError *)error
{
    
}

- (void)receivedQuestionsJSON:(NSString *)objectNotation
{
    
}

@end
