//
//  BrowseOverflow - GravatarCommunicatorTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "GravatarCommunicator.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface GravatarCommunicatorTest : SenTestCase
@property (nonatomic, strong) GravatarCommunicator *sut;
@property (nonatomic, strong) id mockGravatarDelegate;
@property (nonatomic, strong) NSData *fakeData;
@end

@implementation GravatarCommunicatorTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    _mockGravatarDelegate = mockObjectAndProtocol([NSObject class], @protocol(GravatarCommunicatorDelegate));
    
    self.sut = [[GravatarCommunicator alloc] init];
    self.sut.delegate = _mockGravatarDelegate;
    self.sut.url = [NSURL URLWithString: @"http://example.com/avatar"];
    
    self.fakeData = [@"Fake data" dataUsingEncoding: NSUTF8StringEncoding];
}

- (void)tearDown
{
    _sut = nil;
    _fakeData = nil;
    
    [super tearDown];
}

- (void)testThatCommunicatorPassesURLBackWhenCompleted
{
    // when
    [self.sut connectionDidFinishLoading:nil];
    
    // then
    [verify(_mockGravatarDelegate) communicatorReceivedData:nil forURL:self.sut.url];
}

- (void)testThatCommunicatorPassesDataWhenCompleted
{
    // given
    self.sut.receivedData = [self.fakeData mutableCopy];
    
    // when
    [self.sut connectionDidFinishLoading:nil];
    
    // then
    [verify(self.mockGravatarDelegate) communicatorReceivedData:self.fakeData forURL:self.sut.url];
}

- (void)testCommunicatorKeepsURLRequested
{
    // given
    NSURL *differentURL = [NSURL URLWithString: @"http://example.org/notthesameURL"];
    
    // when
    [self.sut fetchDataForURL:differentURL];
    
    // then
    assertThat(self.sut.url, is(equalTo(differentURL)));
}

- (void)testCommunicatorCreatesAURLConnection
{
    // when
    [self.sut fetchDataForURL:self.sut.url];
    
    // then
    assertThat(self.sut.connection, is(notNilValue()));
    [self.sut cancel];
}

- (void)testCommunicatorDiscardsDataWhenResponseReceived
{
    // given
    self.sut.receivedData = [self.fakeData mutableCopy];
    
    // when
    [self.sut connection:nil didReceiveResponse:nil];
    
    // then
    assertThatInteger(self.sut.receivedData.length, is(equalToInteger(0)));
}

- (void)testCommunicatorAppendsReceivedData
{
    // given
    self.sut.receivedData = [self.fakeData mutableCopy];
    
    // when
    NSData *extraData = [@" more" dataUsingEncoding: NSUTF8StringEncoding];
    NSData *expectedData = [@"Fake data more" dataUsingEncoding: NSUTF8StringEncoding];
    [self.sut connection:nil didReceiveData:extraData];
    
    // then
    assertThat([self.sut.receivedData copy], is(equalTo(expectedData)));
}

- (void)testURLPassedBackOnError
{
    // when
    [self.sut connection:nil didFailWithError:nil];
    
    // then
    [verify(self.mockGravatarDelegate) communicatorGotErrorForURL:self.sut.url];
}

- (void)testCancelStopsConnectionAndSetURLAndReceivedDataToNil
{
    // when
    [self.sut fetchDataForURL:[NSURL URLWithString:@"http://www.gravatar.com/avatar/563290c0c1b776a315b36e863b388a0c"]];
    [self.sut cancel];
    
    // then
    assertThat(self.sut.connection, is(nilValue()));
    assertThat(self.sut.url, is(nilValue()));
    assertThat(self.sut.receivedData, is(nilValue()));
}

@end
