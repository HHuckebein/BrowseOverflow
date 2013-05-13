//
//  BrowseOverflow - QuestionTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "Question.h"

    // Collaborators
#import "Answer.h"
#import "Person.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface QuestionTest : SenTestCase
@property (nonatomic, strong) Question  *question;
@property (nonatomic, strong) Person    *asker;
@property (nonatomic, strong) Answer    *acceptedAnswer;
@property (nonatomic, strong) Answer    *lowScoreAnswer;
@property (nonatomic, strong) Answer    *highScoreAnswer;
@end

static NSString *questionJSON = @"{"
@"\"total\": 1,"
@"\"page\": 1,"
@"\"pagesize\": 30,"
@"\"questions\": ["
@"{"
@"\"tags\": ["
@"\"iphone\","
@"\"security\","
@"\"keychain\""
@"],"
@"\"answer_count\": 1,"
@"\"accepted_answer_id\": 3231900,"
@"\"favorite_count\": 1,"
@"\"question_timeline_url\": \"/questions/2817980/timeline\","
@"\"question_comments_url\": \"/questions/2817980/comments\","
@"\"question_answers_url\": \"/questions/2817980/answers\","
@"\"question_id\": 2817980,"
@"\"owner\": {"
@"\"user_id\": 23743,"
@"\"user_type\": \"registered\","
@"\"display_name\": \"Graham Lee\","
@"\"reputation\": 13459,"
@"\"email_hash\": \"563290c0c1b776a315b36e863b388a0c\""
@"},"
@"\"creation_date\": 1273660706,"
@"\"last_activity_date\": 1278965736,"
@"\"up_vote_count\": 2,"
@"\"down_vote_count\": 0,"
@"\"view_count\": 465,"
@"\"score\": 2,"
@"\"community_owned\": false,"
@"\"title\": \"Why does Keychain Services return the wrong keychain content?\","
@"\"body\": \"<p>I've been trying to use persistent keychain references.</p>\""
@"}"
@"]"
@"}";

@implementation QuestionTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.asker = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];

    self.question = [[Question alloc] init];
    self.question.asker = self.asker;
    
    self.acceptedAnswer = [[Answer alloc] init];
    self.acceptedAnswer.score = 1;
    self.acceptedAnswer.accepted = TRUE;
    [self.question addAnswer:self.acceptedAnswer];
    
    self.lowScoreAnswer = [[Answer alloc] init];
    self.lowScoreAnswer.score = -4;
    [self.question addAnswer:self.lowScoreAnswer];
    
    self.highScoreAnswer = [[Answer alloc] init];
    self.highScoreAnswer.score = 4;
    [self.question addAnswer:self.highScoreAnswer];
}

- (void)tearDown
{
    _question = nil;
    _acceptedAnswer = nil;
    _lowScoreAnswer = nil;
    _highScoreAnswer = nil;
    
    [super tearDown];
}

- (void)testQuestionHasADateWhichIsNotNil
{
    assertThat(self.question.date, is(notNilValue()));
}

- (void)testQuestionHasADate
{
    assertThat(self.question.date, is(instanceOf([NSDate class])));
}

- (void)testThatDateIsCorrectlySetWithDate
{
    // given
    NSDate *date = [NSDate distantPast];
    
    // when
    self.question.date = date;
    
    // then
    assertThat(self.question.date, is(equalTo(date)));
}

- (void)testThatQuestionKeepsScore
{
    // when
    self.question.score = 42;
    
    // then
    assertThatInteger(self.question.score, equalToInteger(42));
}

- (void)testQuestionKeepsTitle
{
    // when
    self.question.title = @"Do iPhone also dream of electric sheep?";
    
    // then
    assertThat(self.question.title, equalTo(@"Do iPhone also dream of electric sheep?"));
}

- (void)testThatAnswersReturnAnNSArray
{
    assertThat(self.question.answers, notNilValue());
    assertThat(self.question.answers, instanceOf([NSArray class]));
}

- (void)testAddingAnswersIncrementsCountByThree
{
    // then
    assertThatInteger(self.question.answers.count, equalToInteger(3));
}

- (void)testQuestionWasAskedBySomeone
{
    assertThat(self.question.asker, is(equalTo(self.asker)));
}

- (void)testBuildingQuestionBodyWithNoDataCannotBeTried
{
    STAssertThrows([self.question fillInDetailsFromJSON:nil], @"Not receiving data should have been handled earlier");
}

- (void)testNonJSONDataDoesNotCauseABodyToBeAddedToAQuestion
{
    // given
    NSString *stringIsNotJSON = @"Not JSON";
    
    // when
    [self.question fillInDetailsFromJSON:stringIsNotJSON];
    
    // then
    assertThat(self.question.body, is(nilValue()));
}

- (void)testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded
{
    // given
    NSString *noQuestionsJSONString = @"{ \"noquestions\": true }";
    
    // when
    [self.question fillInDetailsFromJSON:noQuestionsJSONString];
    
    // then
    assertThat(self.question.body, is(nilValue()));
}

- (void)testBodyContainedInJSONIsAddedToQuestion
{
    // when
    [self.question fillInDetailsFromJSON:questionJSON];
    
    // then
    assertThat(self.question.body, is(equalTo(@"<p>I've been trying to use persistent keychain references.</p>")));
}

@end
