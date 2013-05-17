//
//  BrowseOverflow - QuestionTableTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "QuestionTableProvider.h"

    // Collaborators
#import "Topic.h"
#import "Question.h"
#import "Person.h"
#import "QuestionSummaryCell.h"
#import "BrowseOverflowViewController.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface QuestionTableProviderTest : SenTestCase
@property (nonatomic, strong) QuestionTableProvider         *sut;
@property (nonatomic, strong) Topic                         *topic;
@property (nonatomic, strong) Question                      *question1;
@property (nonatomic, strong) Question                      *question2;
@property (nonatomic, strong) Person                        *asker1;
@property (nonatomic, strong) NSIndexPath                   *firstCellIndexPath;
@property (nonatomic, strong) UITableView                   *tableView;
@end

@implementation QuestionTableProviderTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BrowseOverflowViewController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BrowseOverflowViewController class])];
    [controller view];
    self.tableView = controller.tableView;

    self.topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];

    self.sut = [[QuestionTableProvider alloc] init];
    self.sut.topic = self.topic;
    
    self.question1 = [[Question alloc] init];
    self.question1.title = @"Question One";
    self.question1.score = 2;
    
    self.question2 = [[Question alloc] init];
    self.question2.title = @"Question Two";
    
    self.asker1 = [Person personWithName:@"Graham Lee" avatarURL:@"http://www.gravatar.com/avatar/563290c0c1b776a315b36e863b388a0c"];
    
    self.question1.asker = self.asker1;
}

- (void)tearDown
{
    _sut = nil;
    _topic = nil;
    _firstCellIndexPath = nil;
    _question1 = nil;
    _question2 = nil;
    _asker1 = nil;
    
    [super tearDown];
}

- (void)testTopicWithNoQuestionsLeadsToOneRowInTheTable
{
    assertThatInteger([self.sut tableView:nil numberOfRowsInSection:0], is(equalToInteger(1)));
}

- (void)testTopicWithNoQuestionsReturnPlaceholderCellWithCorrectContent
{
    // when
    UITableViewCell *cell = [self.sut tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // then
    assertThat(cell.textLabel.text, is(equalTo(@"There was a problem connecting to the network")));
}

- (void)testTopicWithQuestionsResultsInOneRowPerQuestionInTheTable
{
    // given
    [self.topic addQuestion:self.question1];
    [self.topic addQuestion:self.question2];
    
    // then
    assertThatInteger([self.sut tableView:nil numberOfRowsInSection:0], is(equalToInteger(2)));
}

- (void)testCellPropertiesAreTheSameAsTheQuestion
{
    // given
    [self.topic addQuestion:self.question1];
    
    NSString *locScore = [NSNumberFormatter localizedStringFromNumber:@(self.question1.score) numberStyle:NSNumberFormatterDecimalStyle];
    
    // when
    QuestionSummaryCell *cell = (QuestionSummaryCell *)[self.sut tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // then
    assertThat(cell.nameLabel.text, is(equalTo(self.question1.asker.name)));
    assertThat(cell.titleLabel.text, is(equalTo(self.question1.title)));
    assertThat(cell.scoreLabel.text, is(equalTo(locScore)));
}





@end
