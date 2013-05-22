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
#import "Question+TestExtension.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface QuestionTest : SenTestCase
@property (nonatomic, strong) Question  *sut;
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

@implementation QuestionTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.asker = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];

    self.sut = [[Question alloc] init];
    self.sut.asker = self.asker;
    
    self.acceptedAnswer = [[Answer alloc] init];
    self.acceptedAnswer.score = 1;
    self.acceptedAnswer.accepted = TRUE;
    [self.sut addAnswer:self.acceptedAnswer];
    
    self.lowScoreAnswer = [[Answer alloc] init];
    self.lowScoreAnswer.score = -4;
    [self.sut addAnswer:self.lowScoreAnswer];
    
    self.highScoreAnswer = [[Answer alloc] init];
    self.highScoreAnswer.score = 4;
    [self.sut addAnswer:self.highScoreAnswer];
}

- (void)tearDown
{
    _sut = nil;
    _acceptedAnswer = nil;
    _lowScoreAnswer = nil;
    _highScoreAnswer = nil;
    
    [super tearDown];
}

- (void)testQuestionHasADateWhichIsNotNil
{
    assertThat(self.sut.date, is(notNilValue()));
}

- (void)testQuestionHasADate
{
    assertThat(self.sut.date, is(instanceOf([NSDate class])));
}

- (void)testThatDateIsCorrectlySetWithDate
{
    // given
    NSDate *date = [NSDate distantPast];
    
    // when
    self.sut.date = date;
    
    // then
    assertThat(self.sut.date, is(equalTo(date)));
}

- (void)testThatQuestionKeepsScore
{
    // when
    self.sut.score = 42;
    
    // then
    assertThatInteger(self.sut.score, equalToInteger(42));
}

- (void)testQuestionKeepsTitle
{
    // when
    self.sut.title = @"Do iPhone also dream of electric sheep?";
    
    // then
    assertThat(self.sut.title, equalTo(@"Do iPhone also dream of electric sheep?"));
}

- (void)testThatAnswersReturnAnNSArray
{
    assertThat(self.sut.answers, notNilValue());
    assertThat(self.sut.answers, instanceOf([NSArray class]));
}

- (void)testAddingAnswersIncrementsCountByThree
{
    // then
    assertThatInteger(self.sut.answers.count, equalToInteger(3));
}

- (void)testQuestionWasAskedBySomeone
{
    assertThat(self.sut.asker, is(equalTo(self.asker)));
}

- (void)testBuildingQuestionBodyWithNoDataCannotBeTried
{
    STAssertThrows([self.sut fillInDetailsFromJSON:nil], @"Not receiving data should have been handled earlier");
}

- (void)testNonJSONDataDoesNotCauseABodyToBeAddedToAQuestion
{
    // given
    NSString *stringIsNotJSON = @"Not JSON";
    
    // when
    [self.sut fillInDetailsFromJSON:stringIsNotJSON];
    
    // then
    assertThat(self.sut.body, is(nilValue()));
}

- (void)testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded
{
    // given
    NSString *noQuestionsJSONString = @"{ \"noquestions\": true }";
    
    // when
    [self.sut fillInDetailsFromJSON:noQuestionsJSONString];
    
    // then
    assertThat(self.sut.body, is(nilValue()));
}

- (void)testBodyContainedInJSONIsAddedToQuestion
{
    // when
    [self.sut fillInDetailsFromJSON:questionJSON];
    
    // then
    assertThat(self.sut.body, is(equalTo(@"<p>I've been trying to use persistent keychain references.</p>")));
}

- (void)testCompareForQuestionsWithIdenticalQuestionIDReturnsNSOrderedSame
{
    // given
    self.sut.questionID = 1;

    Question *question1 = [[Question alloc] init];
    question1.questionID = self.sut.questionID;
    
    // then
    assertThatInteger([self.sut compare:question1], is(equalToInteger(NSOrderedSame)));
}

- (void)testCompareForQuestionsWithDifferentQuestionIDsReturnNSOrderesAscending
{
    // given
    self.sut.questionID = 1;
    
    Question *question1 = [[Question alloc] init];
    question1.questionID = self.sut.questionID + 1;
    
    // then
    assertThatInteger([self.sut compare:question1], is(equalToInteger(NSOrderedAscending)));
}

- (void)testCompareForQuestionsWithDifferentQuestionIDsReturnNSOrderedDescending
{
    // given
    self.sut.questionID = 2;
    
    Question *question1 = [[Question alloc] init];
    question1.questionID = self.sut.questionID - 1;
    
    // then
    assertThatInteger([self.sut compare:question1], is(equalToInteger(NSOrderedDescending)));
}

- (void)testThatSendingNilJSONIsNotAnOption
{
    STAssertThrows([self.sut addAnswersFromJSON:nil error:NULL], @"A nil JSON is not allowed");
}

- (void)testSendingNonJSONIsAnErrorWithAnswerBuilderErrorDomain
{
    // given
    NSError *error = nil;
    
    // then
    assertThatBool([self.sut addAnswersFromJSON:fakeJSON error:&error], is(equalToBool(FALSE)));
    assertThat([error domain], is(equalTo(@"AnswerBuilderErrorDomain")));
}

- (void)testSendingNonJSONIsAnErrorWithAnswerBuilderInvalidJSONErrorCode
{
    // given
    NSError *error = nil;
    
    // when
    [self.sut addAnswersFromJSON:fakeJSON error:&error];
    
    // then
    assertThatInteger([error code], is(equalToInteger(AnswerBuilderInvalidJSONError)));
}

- (void)testSendingNonJSONReportsUnderlyingError
{
    // given
    NSError *error = nil;
    
    // when
    [self.sut addAnswersFromJSON:fakeJSON error:&error];
    
    // then
    assertThat([error userInfo], is(notNilValue()));
}

- (void)testErrorParameterMayBeNULL
{
    STAssertNoThrow([self.sut addAnswersFromJSON:fakeJSON error:NULL], @"AnswerBuilder should handle a NULL pointer gracefully");
}

- (void)testAddingRealAnswerJSONIsNotAnError
{
    // given
    NSError *error = nil;
    
    // then
    assertThatBool([self.sut addAnswersFromJSON:realAnswerJSON error:&error], is(equalToBool(TRUE)));
}

- (void)testAddingRealAnswerWithNoContentReportsAnswerBuilderMissingDataError
{
    // given
    NSError *error = nil;
    
    // when
    [self.sut addAnswersFromJSON:noAnswerContentJSON error:&error];
    
    // then
    assertThatInteger([error code], is(equalToInteger(AnswerBuilderMissingDataError)));
}

- (void)testNumberOfAnswersAddedMatchNumberInData
{
    // given
    NSError *error = nil;
    
    // when
    [self.sut addAnswersFromJSON:realAnswerJSON error:&error];
    
    // then
    assertThatInteger(self.sut.answers.count, is(equalToInteger(4)));
}

- (void)testAnswerPropertiesMatchDataReceived
{
    // given
    NSError *error = nil;
    NSString *body = @"<p>Turns out that using the kSecMatchItemList doesn't appear to work at all. </p>";
    
    // when
    [self.sut addAnswersFromJSON:realAnswerJSON error:&error];
    
    Answer *answer = [self.sut answerWithText:body];
    
    // then
    assertThat(answer.text, is(equalTo(body)));
    assertThatInteger(answer.score, is(equalToInteger(3)));
    assertThatBool(answer.accepted, is(equalToBool(TRUE)));
}

- (void)testAnswerIsProvidedByExpectedPerson
{
    // given
    NSError *error = nil;
    NSString *body = @"<p>Turns out that using the kSecMatchItemList doesn't appear to work at all. </p>";
    
    // when
    [self.sut addAnswersFromJSON:realAnswerJSON error:&error];
    
    Answer *answer = [self.sut answerWithText:body];
    Person *person = answer.person;
    
    // then
    assertThat(person.name, is(equalTo(@"dmaclach")));
    assertThat([person.avatarURL absoluteString], is(equalTo(@"http://www.gravatar.com/avatar/d96ae876eac0075727243a10fab823b3")));
}

@end
