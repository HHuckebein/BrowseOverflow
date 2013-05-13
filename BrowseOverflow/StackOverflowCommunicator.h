//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const StackOverflowCommunicatorErrorDomain;

@protocol StackOverflowCommunicatorDelegate;
@interface StackOverflowCommunicator : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <StackOverflowCommunicatorDelegate> delegate;

@property (nonatomic, strong, readonly) NSURL *fetchingURL;
@property (nonatomic, strong, readonly) NSURLConnection *fetchingConnection;

- (void)searchForQuestionsWithTag:(NSString *)tag;
- (void)downloadInformationForQuestionWithID:(NSInteger)identifier;
- (void)downloadAnswersToQuestionWithID:(NSInteger)identifier;

- (void)cancelAndDiscardURLConnection;

- (void)setReceivedData:(NSData *)receivedData;
- (NSData *)receivedData;
@end

@protocol StackOverflowCommunicatorDelegate <NSObject>

- (void)searchingForQuestionsFailedWithError: (NSError *)error;
- (void)fetchingQuestionBodyFailedWithError: (NSError *)error;
- (void)fetchingAnswersFailedWithError: (NSError *)error;
- (void)receivedQuestionsJSON: (NSString *)objectNotation;
- (void)receivedAnswerListJSON: (NSString *)objectNotation;
- (void)receivedQuestionBodyJSON: (NSString *)objectNotation;

@end
