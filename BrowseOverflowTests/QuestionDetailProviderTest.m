//
//  BrowseOverflow - QuestionDetailProviderTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "QuestionDetailProvider.h"

    // Collaborators
#import "AppDelegate.h"
#import "BrowseOverflowViewController.h"
#import "Question.h"
#import "Answer.h"
#import "Person.h"
#import "QuestionDetailCell.h"
#import "AvatarStore+TestExtension.h"
#import "AnswerCell.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface QuestionDetailProviderTest : SenTestCase
@property (nonatomic, strong) QuestionDetailProvider *sut;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) Answer *answer1;
@property (nonatomic, strong) Answer *answer2;
@property (nonatomic, strong) Person *answerer;
@property (nonatomic, strong) Person *asker;
@property (nonatomic, strong) NSIndexPath *questionPath;
@property (nonatomic, strong) NSIndexPath *firstAnswerPath;
@property (nonatomic, strong) NSIndexPath *secondAnswerPath;
@property (nonatomic, strong) NSData *imageData;
@end

@implementation QuestionDetailProviderTest
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

    self.sut = [[QuestionDetailProvider alloc] init];

    self.question = [[Question alloc] init];
    self.question.title = @"Is this a dagger which I see before me, the handle toward my hand?";
    self.question.score = 2;
    self.question.body = @"<p>Come, let me clutch thee. I have thee not, and yet I see thee still. Art thou not, fatal vision, sensible to feeling as to sight?</p>";

    /*note - answer1.score < answer2.score, but answer1 is accepted so should
     *still be first in the list of answers.
     */
    
    self.answer1 = [[Answer alloc] init];
    self.answer1.score = 3;
    self.answer1.accepted = YES;
    self.answer1.text = @"<p>Yes, it is.</p>";

    self.answerer = [[Person alloc] initWithName: @"Banquo" avatarLocation: @"http://example.com/avatar"];
    self.answer1.person = self.answerer;

    self.answer2 = [[Answer alloc] init];
    self.answer2.score = 4;
    self.answer2.accepted = NO;
    [self.question addAnswer:self.answer1];
    [self.question addAnswer:self.answer2];

    self.asker = [[Person alloc] initWithName: @"Graham Lee" avatarLocation: @"http://www.gravatar.com/avatar/563290c0c1b776a315b36e863b388a0c"];
    self.question.asker = self.asker;
    self.sut.question = self.question;
    
    self.questionPath     = [NSIndexPath indexPathForRow:0 inSection:0];
    self.firstAnswerPath  = [NSIndexPath indexPathForRow:0 inSection:1];
    self.secondAnswerPath = [NSIndexPath indexPathForRow:1 inSection:1];

    NSURL *imageURL = [[NSBundle bundleForClass:[self class]] URLForResource: @"JohnDoe" withExtension: @"png"];
    self.imageData = [NSData dataWithContentsOfURL:imageURL];
}

- (void)tearDown
{
    _sut = nil;
    _question = nil;
    _answer1 = nil;
    _answer2 = nil;
    _answerer = nil;
    _asker = nil;
    _questionPath = nil;
    _firstAnswerPath = nil;
    _secondAnswerPath = nil;
    
    [super tearDown];
}


- (void)testTwoSectionsInTheTableView
{
    assertThatInteger([self.sut numberOfSectionsInTableView:self.tableView], is(equalToInteger(2)));
}

- (void)testOneRowInTheFirstSection
{
    assertThatInteger([self.sut tableView:self.tableView numberOfRowsInSection:0], is(equalToInteger(1)));
}

- (void)testQuestionPropertiesAppearInQuestionCell
{
    // given
    QuestionDetailCell *cell = (QuestionDetailCell *)[self.sut tableView:self.tableView cellForRowAtIndexPath:self.questionPath];
    UIWebView *bodyView = cell.bodyWebView;
    
    // when
    /* NASTY HACK ALERT
     * The UIWebView loads its contents asynchronously. If it's still doing
     * that when the test comes to evaluate its content, the content will seem
     * empty and the test will fail. Any solution to this comes down to "hold
     * the test back for a bit", which I've done explicitly here.
     * http://stackoverflow.com/questions/7255515/why-is-my-uiwebview-empty-in-my-unit-test
     */
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.5]];
    NSString *bodyHTML = [bodyView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    
    // then
    assertThat(bodyHTML, is(equalTo(self.question.body)));
    assertThat(cell.titleLabel.text, is(equalTo(self.question.title)));
    assertThatInteger([cell.scoreLabel.text integerValue], is(equalToInteger(self.question.score)));
    assertThat(cell.nameLabel.text, is(equalTo(self.question.asker.name)));
}

- (void)testQuestionCellGetsImageFromAvatarStore
{
    // given
    [[[self appDelegate] avatarStore] setData:self.imageData forLocation:[self.asker.avatarURL absoluteString]];
    
    // when
    QuestionDetailCell *cell = (QuestionDetailCell *)[self.sut tableView:self.tableView cellForRowAtIndexPath:self.questionPath];
    
    // then
    assertThat(cell.avatarView.image, is(notNilValue()));
}


- (void)testAnswerPropertiesAppearInAnswerCell
{
    // when
    AnswerCell *answerCell = (AnswerCell *)[self.sut tableView:self.tableView cellForRowAtIndexPath:self.firstAnswerPath];
    
    // then
    assertThatInteger([answerCell.scoreLabel.text integerValue], is(equalToInteger(3)));
}

- (void)testAcceptedLabelOnlyShownForAcceptedAnswer
{
    // when
    AnswerCell *firstAnswerCell = (AnswerCell *)[self.sut tableView:self.tableView cellForRowAtIndexPath:self.firstAnswerPath];
    AnswerCell *secondAnswerCell = (AnswerCell *)[self.sut tableView:self.tableView cellForRowAtIndexPath:self.secondAnswerPath];
    
    // then
    assertThatBool(firstAnswerCell.acceptedIndicator.hidden, is(equalToBool(FALSE)));
    assertThatBool(secondAnswerCell.acceptedIndicator.hidden, is(equalToBool(TRUE)));
}

- (void)testAnswererPropertiesInAnswerCell
{
    // given
    [[[self appDelegate] avatarStore] setData:self.imageData forLocation:[self.answerer.avatarURL absoluteString]];
    
    // when
    AnswerCell *answerCell = (AnswerCell *)[self.sut tableView:self.tableView cellForRowAtIndexPath:self.firstAnswerPath];
    UIWebView *bodyView = answerCell.bodyWebView;
    /* NASTY HACK ALERT
     * see above
     */
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.5]];
    NSString *bodyHTML = [bodyView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    
    // then
    assertThat(answerCell.personName.text, is(equalTo(self.answerer.name)));
    assertThat(answerCell.personAvatar.image, is(notNilValue()));
    assertThat(bodyHTML, is(equalTo(self.answer1.text)));
}

- (void)testQuestionRowIsAtLeastAsTallAsItsContent
{
    // when
    UITableViewCell *cell = [self.sut tableView:self.tableView cellForRowAtIndexPath:self.questionPath];
    CGFloat height = [self.sut tableView:self.tableView heightForRowAtIndexPath:self.questionPath];
    
    // then
    assertThatBool(height >= cell.frame.size.height, is(equalToBool(TRUE)));
}

- (void)testAnswerRowIsAtLeastAsTallAsItsContent
{
    // when
    UITableViewCell *cell = [self.sut tableView:self.tableView cellForRowAtIndexPath:self.firstAnswerPath];
    CGFloat height = [self.sut tableView:self.tableView heightForRowAtIndexPath:self.firstAnswerPath];
    
    // then
    assertThatBool(height >= cell.frame.size.height, is(equalToBool(TRUE)));
}

#pragma mark - AppDelegate

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
