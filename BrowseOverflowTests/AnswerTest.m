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
@property (nonatomic, strong) Answer *answer;
@property (nonatomic, strong) Answer *anotherAnswer;
@end

@implementation AnswerTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.answer = [[Answer alloc] init];
    self.answer.person = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
    self.answer.score = 42;
    
    self.anotherAnswer = [[Answer alloc] init];
    self.anotherAnswer.score = 42;
}

- (void)tearDown
{
    _answer = nil;
    [super tearDown];
}

- (void)testAnswerHasSomeText
{
    assertThat(self.answer.text, equalTo(@""));
}

- (void)testThatAnswersNotAcceptedByDefault
{
    assertThatBool(self.answer.accepted, equalToBool(FALSE));
}

- (void)testSomeoneProvidedTheAnswer
{
    assertThat(self.answer.person, is(notNilValue()));
    assertThat(self.answer.person, instanceOf([Person class]));
}

- (void)testDefaultAnswerCompareReturnsNSOrderedSame
{
    assertThatInteger([self.answer compare:self.anotherAnswer], equalToInteger(NSOrderedSame));
}

- (void)testAnswerCompareWithEqualAcceptValuesReturnsNSOrderedSame
{
    // when
    self.answer.accepted = TRUE;
    self.anotherAnswer.accepted = TRUE;
    
    // then
    assertThatInteger([self.answer compare:self.anotherAnswer], equalToInteger(NSOrderedSame));
}

- (void)testAcceptedAnswerComesBeforeUnaccepted
{
    // when
    self.anotherAnswer.accepted = TRUE;
    
    // then
    assertThatInteger([self.answer compare:self.anotherAnswer], equalToInteger(NSOrderedAscending));
    assertThatInteger([self.anotherAnswer compare:self.answer], equalToInteger(NSOrderedDescending));
}

- (void)testLowerScoringAnswerComesAfterHigher
{
    // when
    self.anotherAnswer.score = self.answer.score + 10;
    
    // then
    assertThatInteger([self.answer compare:self.anotherAnswer], equalToInteger(NSOrderedAscending));
    assertThatInteger([self.anotherAnswer compare:self.answer], equalToInteger(NSOrderedDescending));
}

@end
