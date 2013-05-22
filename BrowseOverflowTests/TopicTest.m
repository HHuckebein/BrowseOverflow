//
//  BrowseOverflow - TopicTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "Topic.h"

    // Collaborators
#import "Question.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface TopicTest : SenTestCase
@property (nonatomic, strong) Topic *sut;
@end

@implementation TopicTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.sut = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
}

- (void)tearDown
{
    _sut = nil;
    [super tearDown];
}

- (void)testThatTopicExists
{
    self.sut = notNilValue();
}

- (void)testThatTopicCanBeNamed
{
    assertThat(self.sut.name, equalTo(@"iPhone"));
}

- (void)testThatTopicHasATag
{
    assertThat(self.sut.tag, equalTo(@"iphone"));
}

- (void)testThatRecentQuestionsIsNotNil
{
    assertThat([self.sut recentQuestions], notNilValue());
}

- (void)testForAListOfQuestions
{
    assertThat([self.sut recentQuestions], instanceOf([NSArray class]));
}

- (void)testForInitiallyEmptyList
{
    assertThatInteger(self.sut.recentQuestions.count, equalToInteger(0));
}

- (void)testThatAddingAQuestionToTheListYieldsToCountOfOne
{
    // given
    Question *question = [[Question alloc] init];
    
    // when
    [self.sut addQuestion:question];
    
    // then
    assertThatInteger(self.sut.recentQuestions.count, equalToInteger(1));
}

- (void)testQuestionsAreSortedInChronologicalOrderInputWrongOrder
{
    // when
    Question *q1 = [[Question alloc] init];
    q1.date = [NSDate distantPast];
    
    Question *q2 = [[Question alloc] init];
    q2.date = [NSDate distantFuture];
    
    [self.sut addQuestion:q1];
    [self.sut addQuestion:q2];
    
    // then
    assertThat(self.sut.recentQuestions, contains(equalTo(q2), equalTo(q1), nil));
}

- (void)testQuestionsAreSortedInChronologicalOrderInputRightOrder
{
    // when
    Question *q1 = [[Question alloc] init];
    q1.date = [NSDate distantPast];
    
    Question *q2 = [[Question alloc] init];
    q2.date = [NSDate distantFuture];
    
    [self.sut addQuestion:q2];
    [self.sut addQuestion:q1];
    
    // then
    assertThat(self.sut.recentQuestions, contains(equalTo(q2), equalTo(q1), nil));
}

- (void)testLimitOfTwentyQuestions
{
    // when
    Question *q1 = [[Question alloc] init];
    for (int i = 0; i < 25; i++) {
        [self.sut addQuestion:q1];
    }
    
    // then
    assertThatInteger(self.sut.recentQuestions.count, equalToInteger(20));
}

@end
