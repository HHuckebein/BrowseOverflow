//
//  BrowseOverflow - AnswerBuilderTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "AnswerBuilder.h"

    // Collaborators
#import "Question.h"
#import "Answer.h"
#import "Person.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface AnswerBuilderTest : SenTestCase
@property (nonatomic, strong) AnswerBuilder *answerBuilder;
@property (nonatomic, strong) Question *question;
@end

static NSString *const realAnswerJSON = @"{"
@"\"total\": 1,"
@"\"page\": 1,"
@"\"pagesize\": 30,"
@"\"answers\": ["
@"{"
@"\"answer_id\": 3231900,"
@"\"accepted\": true,"
@"\"answer_comments_url\": \"/answers/3231900/comments\","
@"\"question_id\": 2817980,"
@"\"owner\": {"
@"\"user_id\": 266380,"
@"\"user_type\": \"registered\","
@"\"display_name\": \"dmaclach\","
@"\"reputation\": 151,"
@"\"email_hash\": \"d96ae876eac0075727243a10fab823b3\""
@"},"
@"\"creation_date\": 1278965736,"
@"\"last_activity_date\": 1278965736,"
@"\"up_vote_count\": 1,"
@"\"down_vote_count\": 0,"
@"\"view_count\": 0,"
@"\"score\": 3,"
@"\"community_owned\": false,"
@"\"title\": \"Why does Keychain Services return the wrong keychain content?\","
@"\"body\": \"<p>Turns out that using the kSecMatchItemList doesn't appear to work at all. </p>\""
@"}"
@"]"
@"}";

static NSString *const fakeJSON = @"Fake JSON";
static NSString *const noAnswerContentJSON = @"{ \"noanswers\": true }";

@implementation AnswerBuilderTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.answerBuilder = [[AnswerBuilder alloc] init];
    self.question = [[Question alloc] init];
    self.question.questionID = 12345;
}

- (void)tearDown
{
    _answerBuilder = nil;
    [super tearDown];
}

- (void)testThatSendingNilJSONIsNotAnOption
{
    STAssertThrows([self.answerBuilder addAnswersToQuestion:self.question fromJSON:nil error:NULL], @"A nil JSON is not allowed");
}

- (void)testThatAddingAnswersToNilQuestionIsNotAllowed
{
    // given
    
    
    // then
    STAssertThrows([self.answerBuilder addAnswersToQuestion:nil fromJSON:fakeJSON error:NULL], @"Adding answers to a nil question is not supported");
}


- (void)testSendingNonJSONIsAnErrorWithAnswerBuilderErrorDomain
{
    // given
    NSError *error = nil;
    
    // then
    assertThatBool([self.answerBuilder addAnswersToQuestion:self.question fromJSON:fakeJSON error:&error], is(equalToBool(FALSE)));
    assertThat([error domain], is(equalTo(@"AnswerBuilderErrorDomain")));
}

- (void)testSendingNonJSONIsAnErrorWithAnswerBuilderInvalidJSONErrorCode
{
    // given
    NSError *error = nil;
    
    // when
    [self.answerBuilder addAnswersToQuestion:self.question fromJSON:fakeJSON error:&error];
    
    // then
    assertThatInteger([error code], is(equalToInteger(AnswerBuilderInvalidJSONError)));
}

- (void)testSendingNonJSONReportsUnderlyingError
{
    // given
    NSError *error = nil;
    
    // when
    [self.answerBuilder addAnswersToQuestion:self.question fromJSON:fakeJSON error:&error];
    
    // then
    assertThat([error userInfo], is(notNilValue()));
}

- (void)testErrorParameterMayBeNULL
{
    STAssertNoThrow([self.answerBuilder addAnswersToQuestion:self.question fromJSON:fakeJSON error:NULL], @"AnswerBuilder should handle a NULL pointer gracefully");
}

- (void)testAddingRealAnswerJSONIsNotAnError
{
    // given
    NSError *error = nil;
    
    // then
    assertThatBool([self.answerBuilder addAnswersToQuestion:self.question fromJSON:realAnswerJSON error:&error], is(equalToBool(TRUE)));
}

- (void)testAddingRealAnswerWithNoContentReportsAnswerBuilderMissingDataError
{
    // given
    NSError *error = nil;
    
    // when
    [self.answerBuilder addAnswersToQuestion:self.question fromJSON:noAnswerContentJSON error:&error];
    
    // then
    assertThatInteger([error code], is(equalToInteger(AnswerBuilderMissingDataError)));
}

- (void)testNumberOfAnswersAddedMatchNumberInData
{
    // given
    NSError *error = nil;
    
    // when
    [self.answerBuilder addAnswersToQuestion:self.question fromJSON:realAnswerJSON error:&error];
    
    // then
    assertThatInteger(self.question.answers.count, is(equalToInteger(1)));
}

- (void)testAnswerPropertiesMatchDataReceived
{
    // given
    NSError *error = nil;
    
    // when
    [self.answerBuilder addAnswersToQuestion:self.question fromJSON:realAnswerJSON error:&error];
    
    Answer *answer = self.question.answers[0];
    
    // then
    assertThat(answer.text, is(equalTo(@"<p>Turns out that using the kSecMatchItemList doesn't appear to work at all. </p>")));
    assertThatInteger(answer.score, is(equalToInteger(3)));
    assertThatBool(answer.accepted, is(equalToBool(TRUE)));
}

- (void)testAnswerIsProvidedByExpectedPerson
{
    // given
    NSError *error = nil;
    
    // when
    [self.answerBuilder addAnswersToQuestion:self.question fromJSON:realAnswerJSON error:&error];
    
    Answer *answer = self.question.answers[0];
    Person *person = answer.person;
    
    // then
    assertThat(person.name, is(equalTo(@"dmaclach")));
    assertThat([person.avatarURL absoluteString], is(equalTo(@"http://www.gravatar.com/avatar/d96ae876eac0075727243a10fab823b3")));
}

@end
