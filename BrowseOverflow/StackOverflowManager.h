//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicator.h"

extern NSString *const StackOverflowManagerError;

NS_ENUM(NSUInteger, StackOverflowManagerErrorCode) {
    StackOverflowManagerErrorQuestionSearch, 
    StackOverflowManagerErrorQuestionBodyFetchCode
};

@protocol StackOverflowManagerDelegate;
@class Topic, QuestionBuilder, Question;

@interface StackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>
@property (nonatomic, weak  ) id <StackOverflowManagerDelegate> delegate;
@property (nonatomic, strong) StackOverflowCommunicator         *communicator;
@property (nonatomic, strong) QuestionBuilder                   *questionBuilder;
@property (nonatomic, strong,readonly) Question                 *questionToFill;

- (void)fetchQuestionsOnTopic:(Topic *)topic;
- (void)fetchBodyForQuestion:(Question *)question;
- (void)searchingForQuestionsOnTopic:(Topic *)topic failedWithError:(NSError *)error;
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error;
- (void)receivedQuestionJSON:(NSString *)objectNotation;
- (void)receivedQuestionBodyJSON:(NSString *)objectNotation;
@end

@protocol StackOverflowManagerDelegate <NSObject>
- (void)fetchingQuestionsFailedWithError:(NSError *)error;
- (void)fetchingQuestionBodyFailedWithError: (NSError *)error;
- (void)bodyReceivedForQuestion: (Question *)question;
@end