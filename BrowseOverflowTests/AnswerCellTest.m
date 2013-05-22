//
//  BrowseOverflow - AnswerCellTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "AnswerCell.h"

    // Collaborators
#import "BrowseOverflowViewController.h"
#import "QuestionDetailProvider.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface AnswerCellTest : SenTestCase
@property (nonatomic, strong) AnswerCell *sut;
@end

@implementation AnswerCellTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BrowseOverflowViewController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BrowseOverflowViewController class])];
    [controller view];
    
    self.sut = [controller.tableView dequeueReusableCellWithIdentifier:answerCellReuseIdentifier];
}

- (void)tearDown
{
    _sut = nil;
    [super tearDown];
}

- (void)testAcceptedIndicatorShouldBeConnected
{
    // then
    assertThat([self.sut acceptedIndicator], is(notNilValue()));
}

- (void)testPersonNameLabelShouldBeConnected
{
    // then
    assertThat([self.sut personName], is(notNilValue()));
}

- (void)testScoreLabelShouldBeConnected
{
    // then
    assertThat([self.sut scoreLabel], is(notNilValue()));
}

- (void)testPersonAvatarViewShouldBeConnected
{
    // then
    assertThat([self.sut personAvatar], is(notNilValue()));
}

- (void)testBodyWebViewShouldBeConnected
{
    assertThat([self.sut bodyWebView], is(notNilValue()));
}
@end
