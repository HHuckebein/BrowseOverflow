//
//  BrowseOverflow - QuestionCreationTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "StackOverflowManager.h"

    // Collaborators
#import "Question.h"
#import "StackOverflowCommunicator.h"
#import "StackOverflowManagerDelegate.h"
#import "MockStackOverflowManagerDelegate.h"
#import "Topic.h"
#import "QuestionBuilder.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

NSString *const fakeJSON = @"FAKE JSON";

@interface QuestionCreationWorkflowTest : SenTestCase
@property (nonatomic, strong) StackOverflowManager *mgr;
@property (nonatomic, strong) Topic *topic;
@property (nonatomic, strong) id <StackOverflowManagerDelegate> delegate;
@property (nonatomic, strong) StackOverflowCommunicator *mockCommunicator;
@property (nonatomic, strong) QuestionBuilder *mockQuestionBuilder;

@property (nonatomic, strong) NSError *underlyingError;

@property (nonatomic, strong) Question *questionToFetch;
@property (nonatomic, strong) NSArray *questionArray;
@end

@implementation QuestionCreationWorkflowTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.mgr = [[StackOverflowManager alloc] init];

    self.topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    
    self.delegate = (id <StackOverflowManagerDelegate>)[[MockStackOverflowManagerDelegate alloc] init];
        
    self.mockCommunicator = mock([StackOverflowCommunicator class]);
    self.mgr.communicator = self.mockCommunicator;
    
    self.questionToFetch = [[Question alloc] init];
    self.questionToFetch.questionID = 1234;
    
    self.questionArray = @[self.questionToFetch];

    self.mockQuestionBuilder = mock([QuestionBuilder class]);
    
    self.underlyingError = [NSError errorWithDomain:@"Test Domain" code:0 userInfo:nil];
}

- (void)tearDown
{
    _mgr = nil;
    _topic = nil;
    _mockCommunicator = nil;
    _delegate = nil;
    _mockQuestionBuilder = nil;
    _questionToFetch = nil;
    _questionArray = nil;
    _underlyingError = nil;
    
    [super tearDown];
}

- (void)testStackOverflowManagerAcceptsNilAsDelegate
{
    STAssertNoThrow(self.mgr.delegate = nil, nil);
}

- (void)testStackOverflowManagerShouldRaiseExceptionIfDelegateDoesNotConformToProtocol
{
    // given
    id delegate = [[NSObject alloc] init];
    
    // then
    STAssertThrows(self.mgr.delegate = delegate, nil);
}

- (void)testStackOverflowManagerShouldAcceptDelegateWhichDoesConformToProtocol
{
    STAssertNoThrow(self.mgr.delegate = _delegate, nil);
}

- (void)testAskingForQuestionsMeansRequestingData
{
    // when
    [self.mgr fetchQuestionsOnTopic:self.topic];
    
    // then
    [verify(self.mockCommunicator) searchForQuestionsWithTag:self.topic.tag];
}


- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    // given
    self.mgr.delegate = _delegate;
    
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorQuestionSearch
                                               userInfo:@{NSUnderlyingErrorKey : self.underlyingError}];

    // when
    [self.mgr searchingForQuestionsOnTopic:self.topic failedWithError:self.underlyingError];
    
    // then
    assertThat(((MockStackOverflowManagerDelegate *)_delegate).fetchedError, equalTo(reportableError));
}

- (void)testQuestionJSONIsPassedToQuestionBuilder
{
    // given
    self.mgr.delegate = _delegate;
    self.mgr.questionBuilder = self.mockQuestionBuilder;
    
    // when
    [self.mgr receivedQuestionJSON:fakeJSON];
    
    // then
    [verify(self.mockQuestionBuilder) questionsFromJSON:fakeJSON error:nil];
    self.mgr.questionBuilder = nil;
}

- (void)testDelegateNotifiedOfErrorWhenQuestionBuilderFails
{
    // given
    self.mgr.delegate = _delegate;
    self.mgr.questionBuilder = self.mockQuestionBuilder;
    
    // when
    [self.mgr receivedQuestionJSON:fakeJSON];
    
    // then
    assertThat(((MockStackOverflowManagerDelegate *)_delegate).fetchedError.domain, equalTo(StackOverflowManagerError));
    self.mgr.questionBuilder = nil;
}

- (void)testAskingForQuestionBodyMeansRequestingData
{
    // given
    self.mgr.delegate = _delegate;
    self.mgr.questionBuilder = self.mockQuestionBuilder;

    // when
    [self.mgr fetchBodyForQuestion:self.questionToFetch];
    
    // then
    [verify(self.mockCommunicator) downloadInformationForQuestionWithID:self.questionToFetch.questionID];
}

- (void)testDelegateNotifiedOfFailureToFetchQuestion
{
    // given
    self.mgr.delegate = _delegate;
    
    // when
    [self.mgr fetchingQuestionBodyFailedWithError:self.underlyingError];
    
    // then
    assertThat(((MockStackOverflowManagerDelegate *)_delegate).fetchedError.userInfo[NSUnderlyingErrorKey], is(notNilValue()));
}

- (void)testManagerPassesRetrievedQuestionBodyToQuestionBuilder
{
    // given
    self.mgr.delegate = _delegate;
    self.mgr.questionBuilder = self.mockQuestionBuilder;
    
    // when
    [self.mgr fetchBodyForQuestion:self.questionToFetch];
    [self.mgr receivedQuestionBodyJSON:fakeJSON];
    
    // then
    assertThat(((MockStackOverflowManagerDelegate *)self.mgr.delegate).bodyQuestion, is(equalTo(self.questionToFetch)));
    self.mgr.questionBuilder = nil;
}

@end
