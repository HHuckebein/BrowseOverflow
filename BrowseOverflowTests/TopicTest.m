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

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface TopicTest : SenTestCase
@property (nonatomic, strong) Topic *topic;
@end

@implementation TopicTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    _topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
}

- (void)tearDown
{
    _topic = nil;
    [super tearDown];
}

- (void)testThatTopicExists
{
    self.topic = notNilValue();
}

- (void)testThatTopicCanBeNamed
{
    assertThat(self.topic.name, equalTo(@"iPhone"));
}

- (void)testThatTopicHasATag
{
    assertThat(self.topic.tag, equalTo(@"iphone"));
}

- (void)testThatRecentQuestionsIsNotNil
{
    assertThat([self.topic recentQuestions], notNilValue());
}

- (void)testForAListOfQuestions
{
    assertThat([self.topic recentQuestions], instanceOf([NSArray class]));
}

- (void)testForInitiallyEmptyList
{
    assertThatInteger(self.topic.recentQuestions.count, equalToInteger(0));
}

- (void)testThatAddingAQuestionToTheListYieldsToCountOfOne
{
    // given
    Question *question = [[Question alloc] init];
    
    // when
    [self.topic addQuestion:question];
    
    // then
    assertThatInteger(self.topic.recentQuestions.count, equalToInteger(1));
}

- (void)testQuestionsAreSortedInChronologicalOrderInputWrongOrder
{
    // when
    Question *q1 = [[Question alloc] init];
    q1.date = [NSDate distantPast];
    
    Question *q2 = [[Question alloc] init];
    q2.date = [NSDate distantFuture];
    
    [self.topic addQuestion:q1];
    [self.topic addQuestion:q2];
    
    // then
    assertThat(self.topic.recentQuestions, contains(equalTo(q2), equalTo(q1), nil));
}

- (void)testQuestionsAreSortedInChronologicalOrderInputRightOrder
{
    // when
    Question *q1 = [[Question alloc] init];
    q1.date = [NSDate distantPast];
    
    Question *q2 = [[Question alloc] init];
    q2.date = [NSDate distantFuture];
    
    [self.topic addQuestion:q2];
    [self.topic addQuestion:q1];
    
    // then
    assertThat(self.topic.recentQuestions, contains(equalTo(q2), equalTo(q1), nil));
}

- (void)testLimitOfTwentyQuestions
{
    // when
    Question *q1 = [[Question alloc] init];
    for (int i = 0; i < 25; i++) {
        [self.topic addQuestion:q1];
    }
    
    // then
    assertThatInteger(self.topic.recentQuestions.count, equalToInteger(20));
}

@end
