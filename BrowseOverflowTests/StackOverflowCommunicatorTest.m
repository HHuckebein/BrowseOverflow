//
//  BrowseOverflow - StackOverflowCommunicatorTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "StackOverflowCommunicator.h"

    // Collaborators
#import "NoNetworkStackOverflowCommunicator.h"
#import "StackOverflowManager.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface StackOverflowCommunicatorTest : SenTestCase
@property (nonatomic, strong) StackOverflowCommunicator             *sut;
@property (nonatomic, strong) NoNetworkStackOverflowCommunicator    *nnCommunicator;
@property (nonatomic, strong) StackOverflowManager                  *mockManager;
@property (nonatomic, strong) NSURLResponse                         *mockResponse;
@property (nonatomic, strong) NSData                                *receivedData;
@end

@implementation StackOverflowCommunicatorTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.sut = [[StackOverflowCommunicator alloc] init];

    self.mockManager = mockObjectAndProtocol([StackOverflowManager class], @protocol(StackOverflowCommunicatorDelegate));

    self.nnCommunicator = [[NoNetworkStackOverflowCommunicator alloc] init];
    self.nnCommunicator.delegate = self.mockManager;
    
    self.mockResponse = mock([NSURLResponse class]);
    
    self.receivedData = [@"Result" dataUsingEncoding: NSUTF8StringEncoding];
}

- (void)tearDown
{
    _sut = nil;
    _nnCommunicator = nil;
    [super tearDown];
}


- (void)testSearchingForQuestionsOnTopicCallsTopicAPI
{
    // when
    [self.sut searchForQuestionsWithTag:@"ios"];
    
    // then
    assertThat([self.sut.fetchingURL absoluteString], is(equalTo(@"http://api.stackoverflow.com/1.1/search?tagged=ios&pagesize=20")));
}

- (void)testFillingInQuestionBodyCallsQuestionAPI
{
    // when
    [self.sut downloadInformationForQuestionWithID:12345];
    
    // then
    assertThat([self.sut.fetchingURL absoluteString], is(equalTo(@"http://api.stackoverflow.com/1.1/questions/12345?body=true")));
}

- (void)testFetchingAnswersToQuestionCallsQuestionAPI
{
    // when
    [self.sut downloadAnswersToQuestionWithID:12345];
    
    // then
    assertThat([self.sut.fetchingURL absoluteString], is(equalTo(@"http://api.stackoverflow.com/1.1/questions/12345/answers?body=true")));
}

- (void)testSearchingForQuestionsCreatesURLConnection
{
    // when
    [self.sut searchForQuestionsWithTag:@"ios"];
    
    // then
    assertThat(self.sut.fetchingConnection, is(notNilValue()));
    [self.sut cancelAndDiscardURLConnection];
}


- (void)testStartingNewSearchThrowsOutOldConnection
{
    // when
    [self.sut searchForQuestionsWithTag:@"ios"];
    
    NSURLConnection *firstConnection = [self.sut fetchingConnection];
    [self.sut searchForQuestionsWithTag:@"cocoa"];
    
    // then
    assertThat(self.sut.fetchingConnection, isNot(equalTo(firstConnection)));
    [self.sut cancelAndDiscardURLConnection];
}

- (void)testReceivingResponseDiscardsExistingData
{
    // given
    [self.nnCommunicator setReceivedData:[@"Hello" dataUsingEncoding: NSUTF8StringEncoding]];
    
    // when
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    [self.nnCommunicator connection:nil didReceiveResponse:nil];
    
    // then
    assertThatInteger([self.nnCommunicator.receivedData length], is(equalToInteger(0)));
}

- (void)testReceivingResponseWith404StatusPassesErrorToDelegate
{
    // given
    [given([(NSHTTPURLResponse *)self.mockResponse statusCode]) willReturnInteger:404];
    
    NSError *error = [NSError errorWithDomain: StackOverflowCommunicatorErrorDomain code:404 userInfo: nil];
    
    //when
    [self.nnCommunicator searchForQuestionsWithTag: @"ios"];
    [self.nnCommunicator connection: nil didReceiveResponse:self.mockResponse];
    
    // then
    [verify(self.mockManager) searchingForQuestionsFailedWithError:error];
}

- (void)testNoErrorReceivedOn200Status
{
    // given
    [given([(NSHTTPURLResponse *)self.mockResponse statusCode]) willReturnInteger:200];
    
    //when
    [self.nnCommunicator searchForQuestionsWithTag: @"ios"];
    [self.nnCommunicator connection:nil didReceiveResponse:self.mockResponse];
    
    // then
    assertThatBool([self.nnCommunicator.receivedData isKindOfClass:[NSData class]], is(equalToBool(TRUE)));
}

- (void)testReceiving404ResponseToQuestionBodyRequestPassesErrorToDelegate
{
    // given
    [given([(NSHTTPURLResponse *)self.mockResponse statusCode]) willReturnInteger:404];
    
    NSError *error = [NSError errorWithDomain:StackOverflowCommunicatorErrorDomain code:404 userInfo:nil];
    
    // when
    [self.nnCommunicator downloadInformationForQuestionWithID:1234];
    [self.nnCommunicator connection:nil didReceiveResponse:self.mockResponse];
    
    // then
    [verify(self.mockManager) fetchingQuestionBodyFailedWithError:error];
}

- (void)testReceiving404ResponseToAnswerRequestPassesErrorToDelegate
{
    // given
    [given([(NSHTTPURLResponse *)self.mockResponse statusCode]) willReturnInteger:404];
    
    NSError *error = [NSError errorWithDomain:StackOverflowCommunicatorErrorDomain code:404 userInfo:nil];
    
    // when
    [self.nnCommunicator downloadAnswersToQuestionWithID:1234];
    [self.nnCommunicator connection:nil didReceiveResponse:self.mockResponse];
    
    // then
    [verify(self.mockManager) fetchingAnswersFailedWithError:error];
}

- (void)testConnectionFailingPassesErrorToDelegate
{
    // given
    NSError *error = [NSError errorWithDomain:@"Fake Domain" code:12345 userInfo:nil];
    
    // when
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    [self.nnCommunicator connection:nil didFailWithError:error];
    
    // then
    assertThat(self.nnCommunicator.receivedData, is(nilValue()));
    assertThat(self.nnCommunicator.fetchingConnection, is(nilValue()));
    assertThat(self.nnCommunicator.fetchingURL, is(nilValue()));
    
    [verify(self.mockManager) searchingForQuestionsFailedWithError:error];
}

- (void)testSuccessfulQuestionSearchPassesDataToDelegate
{
    // given
    [self.nnCommunicator setReceivedData:self.receivedData];

    // when
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    [self.nnCommunicator connectionDidFinishLoading:nil];
    
    // then
    assertThat(self.nnCommunicator.fetchingConnection, is(nilValue()));
    assertThat(self.nnCommunicator.fetchingURL, is(nilValue()));
    assertThat(self.nnCommunicator.receivedData, is(nilValue()));

    [verify(self.mockManager) receivedQuestionsJSON:@"Result"];
}

- (void)testAdditionalDataAppendedToDownload
{
    // given
    [self.nnCommunicator setReceivedData:self.receivedData];
    NSData *extraData = [@" appended" dataUsingEncoding: NSUTF8StringEncoding];
    
    NSMutableData *combinedData = [NSMutableData data];
    [combinedData appendData:self.receivedData];
    [combinedData appendData:extraData];
    
    // when
    [self.nnCommunicator connection:nil didReceiveData:extraData];
    
    // then
    assertThat(self.nnCommunicator.receivedData, is(equalTo(combinedData)));
}

@end
