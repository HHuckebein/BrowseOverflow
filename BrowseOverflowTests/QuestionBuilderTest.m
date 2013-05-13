//
//  BrowseOverflow - QuestionBuilderTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "QuestionBuilder.h"

    // Collaborators
#import "Question.h"
#import "Person.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


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

@interface QuestionBuilderTest : SenTestCase
@property (nonatomic, strong) QuestionBuilder *questionBuilder;
@property (nonatomic, strong) Question *question;
@end

@implementation QuestionBuilderTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.questionBuilder = [[QuestionBuilder alloc] init];
    self.question = [[self.questionBuilder questionsFromJSON:questionJSON error:NULL] objectAtIndex:0];
}

- (void)tearDown
{
    _questionBuilder = nil;
    _question = nil;
    
    [super tearDown];
}

- (void)testThatNilIsNotAnAcceptableParameter
{
    STAssertThrows([self.questionBuilder questionsFromJSON:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    assertThat([self.questionBuilder questionsFromJSON:@"Not JSON" error:NULL], is(nilValue()));
}

- (void)testErrorSetWhenStringIsNotJSON
{
    // given
    NSError *error = nil;
    
    // when
    [self.questionBuilder questionsFromJSON:@"Not JSON" error:&error];
    
    // then
    assertThat(error, is(notNilValue()));
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
   STAssertNoThrow([self.questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"Using a NULL parameter should not be a problem");
}

- (void)testRealJSONWithoutQuestionsArrayIsError {
    NSString *jsonString = @"{ \"noquestions\": true }";
    assertThat([self.questionBuilder questionsFromJSON:jsonString error:NULL], is(nilValue()));
}

- (void)testRealJSONWithoutQuestionsReturnsMissingDataErro
{
    // given
    NSError *error = nil;
    
    // when
    [self.questionBuilder questionsFromJSON:@"{\"noquestions\": true}" error:&error];
    
    // then
    assertThatUnsignedInteger([error code], is(equalToUnsignedInteger(QuestionBuilderMissingDataError)));
}

- (void)testJSONWithOneQuestionReturnsOneQuestionObject
{
    // given
    NSError *error = nil;
    
    // then
    assertThatInteger([[self.questionBuilder questionsFromJSON: questionJSON error: &error] count], is(equalToInteger(1)));
}


- (void)testQuestionCreatedFromJSONHasPropertiesPresentedInJSON
{
    // then
    assertThatInteger(self.question.questionID, is(equalToInteger(2817980)));
    assertThatDouble([self.question.date timeIntervalSince1970], is(equalToDouble((NSTimeInterval)1273660706)));
    assertThat(self.question.title, is(equalTo(@"Why does Keychain Services return the wrong keychain content?")));
    assertThatInteger(self.question.score, is(equalToInteger(2)));
    
    Person *asker = self.question.asker;
    assertThat(asker.name, is(equalTo(@"Graham Lee")));
    assertThat([asker.avatarURL absoluteString], is(equalTo(@"http://www.gravatar.com/avatar/563290c0c1b776a315b36e863b388a0c")));
}

- (void)testQuestionCreatedFromEmptyObjectIsStillValidObject
{
    // given
    NSString *emptyQuestion = @"{ \"questions\": [ {} ] }";

    // when
    NSArray *questions = [self.questionBuilder questionsFromJSON:emptyQuestion error:NULL];
    
    // then
    assertThatInteger(questions.count, is(equalToInteger(1)));
}

@end
