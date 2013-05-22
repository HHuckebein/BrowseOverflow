//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"
#import "StackOverflowCommunicatorDelegate.h"

extern NSString *const StackOverflowManagerError;

NS_ENUM(NSUInteger, StackOverflowManagerErrorCode) {
    StackOverflowManagerErrorQuestionSearch, 
    StackOverflowManagerErrorQuestionBodyFetchCode,
    StackOverflowManagerErrorAnswerFetchCode
};

@class Topic, QuestionBuilder, Question, StackOverflowCommunicator, AnswerBuilder;

@interface StackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>
@property (nonatomic, weak  ) id <StackOverflowManagerDelegate> delegate;
@property (nonatomic, strong) StackOverflowCommunicator         *communicator;
@property (nonatomic, strong) StackOverflowCommunicator         *bodyCommunicator;
@property (nonatomic, strong) QuestionBuilder                   *questionBuilder;
@property (nonatomic, strong) AnswerBuilder                     *answerBuilder;
@property (nonatomic, strong,readonly) Question                 *questionToFill;

- (void)fetchQuestionsOnTopic:(Topic *)topic;

- (void)fetchBodyForQuestion:(Question *)question;

- (void)fetchAnswersForQuestion: (Question *)question;

@end

