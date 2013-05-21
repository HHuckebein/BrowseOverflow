//
//  BrowseOverflow - AnswerTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "Answer.h"

    // Collaborators
#import "Person.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface AnswerTest : SenTestCase
@property (nonatomic, strong) Answer *sut;
@property (nonatomic, strong) Answer *anotherAnswer;
@end

@implementation AnswerTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.sut = [[Answer alloc] init];
    self.sut.person = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
    self.sut.score = 42;
    
    self.anotherAnswer = [[Answer alloc] init];
    self.anotherAnswer.score = 42;
}

- (void)tearDown
{
    _sut = nil;
    _anotherAnswer = nil;
    
    [super tearDown];
}

- (void)testAnswerHasSomeText
{
    assertThat(self.sut.text, equalTo(@""));
}

- (void)testThatAnswersNotAcceptedByDefault
{
    assertThatBool(self.sut.accepted, equalToBool(FALSE));
}

- (void)testSomeoneProvidedTheAnswer
{
    assertThat(self.sut.person, is(notNilValue()));
    assertThat(self.sut.person, instanceOf([Person class]));
}

- (void)testDefaultAnswerCompareReturnsNSOrderedSame
{
    assertThatInteger([self.sut compare:self.anotherAnswer], equalToInteger(NSOrderedSame));
}

- (void)testAnswerCompareWithEqualAcceptValuesReturnsNSOrderedSame
{
    // when
    self.sut.accepted = TRUE;
    self.anotherAnswer.accepted = TRUE;
    
    // then
    assertThatInteger([self.sut compare:self.anotherAnswer], equalToInteger(NSOrderedSame));
}

- (void)testAcceptedAnswerComesBeforeUnaccepted
{
    // when
    self.anotherAnswer.accepted = TRUE;
    
    // then
    assertThatInteger([self.sut compare:self.anotherAnswer], equalToInteger(NSOrderedAscending));
    assertThatInteger([self.anotherAnswer compare:self.sut], equalToInteger(NSOrderedDescending));
}

- (void)testLowerScoringAnswerComesAfterHigher
{
    // when
    self.anotherAnswer.score = self.sut.score + 10;
    
    // then
    assertThatInteger([self.sut compare:self.anotherAnswer], equalToInteger(NSOrderedAscending));
    assertThatInteger([self.anotherAnswer compare:self.sut], equalToInteger(NSOrderedDescending));
}

@end
