//
//  BrowseOverflow - AvatarStoreTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "AvatarStore.h"

    // Collaborators
#import "AvatarStore+TestExtension.h"
#import "GravatarCommunicator.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface AvatarStoreTest : SenTestCase
@property (nonatomic, strong) AvatarStore *sut;
@property (nonatomic, strong) NSData *sampleData;
@property (nonatomic, strong) NSString *sampleLocation;
@property (nonatomic, strong) NSString *otherLocation;

@property (nonatomic, assign) NSInteger notificationReceived;

@end

@implementation AvatarStoreTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.sut = [[AvatarStore alloc] init];
    
    self.sampleLocation = @"http://example.com/avatar/sample";
    self.otherLocation = @"http://example.com/avatar/other";

    self.sampleData = [@"sample data" dataUsingEncoding: NSUTF8StringEncoding];
    [self.sut setData:self.sampleData forLocation:self.sampleLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentReceivedNotificationReceived:) name:AvatarStoreDidUpdateContentNotification object:self.sut];
}

- (void)tearDown
{
    _sut = nil;
    _sampleData = nil;
    _otherLocation = nil;
    _sampleLocation = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super tearDown];
}

- (void)testDefaultDataReturnsNonNilValue
{
    assertThat([self.sut defaultData], is(notNilValue()));
}

- (void)testDataForURLReturnsNilIfURLIsMissing
{
    assertThat([self.sut dataForURL:nil], is(nilValue()));
}

- (void)testCacheMissReturnsNoData {
    assertThat([self.sut dataForURL:[NSURL URLWithString:self.otherLocation]], is(nilValue()));
}

- (void)testCacheMissCreatesNewCommunicator {
    
    // when
    [self.sut dataForURL:[NSURL URLWithString:self.otherLocation]];
    GravatarCommunicator *communicator = self.sut.communicators[self.otherLocation];
    
    // then
    assertThat(self.sut.communicators[self.otherLocation], is(notNilValue()));
    
    assertThat(communicator, is(notNilValue()));
    [communicator cancel];
}

- (void)testStoreRetrievedDataFromCommunicator
{
    // given
    NSURL *otherURL = [NSURL URLWithString:self.otherLocation];

    // when
    [self.sut communicatorReceivedData:self.sampleData forURL:otherURL];

    // then
    assertThat([self.sut dataForURL:otherURL], is(equalTo(self.sampleData)));
}

- (void)testStoreSendsDataUpdateNotificationWhenDataRetrieved
{
    // when
    [self.sut communicatorReceivedData:self.sampleData forURL: [NSURL URLWithString:self.otherLocation]];
    
    // then
    assertThatInteger(_notificationReceived, is(equalToInteger(1)));
}

- (void)testStoreDiscardsCommunicatorOnCompletion
{
    // when
    [self.sut dataForURL:[NSURL URLWithString:self.otherLocation]];
    [self.sut communicatorReceivedData:self.sampleData forURL:[NSURL URLWithString:self.otherLocation]];
    
    // then
    assertThat(self.sut.communicators[self.otherLocation], is(nilValue()));
}

- (void)testStoreDiscardsCommunicatorOnFailure
{
    // given
    NSURL *otherURL = [NSURL URLWithString:self.otherLocation];

    // when
    [self.sut dataForURL:otherURL];
    [self.sut communicatorGotErrorForURL:otherURL];

    // then
    assertThat(self.sut.communicators[self.otherLocation], is(nilValue()));
}

- (void)testStoreDoesNotUseAnyDataOnError
{
    // given
    NSURL *otherURL = [NSURL URLWithString:self.otherLocation];
    
    // when
    [self.sut dataForURL:otherURL];
    [self.sut communicatorGotErrorForURL:otherURL];
    
    // then
    assertThatBool([self.sut containsDataForLocation:self.otherLocation], is(equalToBool(FALSE)));
}


- (void)contentReceivedNotificationReceived:(NSNotification *)notification
{
    ++_notificationReceived;
}

@end
