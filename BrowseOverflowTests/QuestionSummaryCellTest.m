//
//  BrowseOverflow - QuestionSummaryCellTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "QuestionSummaryCell.h"

    // Collaborators
#import "BrowseOverflowViewController.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface QuestionSummaryCellTest : SenTestCase
@property (nonatomic, strong) QuestionSummaryCell *sut;
@end

@implementation QuestionSummaryCellTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BrowseOverflowViewController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BrowseOverflowViewController class])];
    [controller view];
    
    self.sut = [controller.tableView dequeueReusableCellWithIdentifier:@"QuestionCellStyle"];
}

- (void)tearDown
{
    _sut = nil;
    [super tearDown];
}

- (void)testTitleLabelShouldBeConnected
{
    // then
    assertThat([self.sut titleLabel], is(notNilValue()));
}

- (void)testNameLabelShouldBeConnected
{
    // then
    assertThat([self.sut nameLabel], is(notNilValue()));
}

- (void)testScoreLabelShouldBeConnected
{
    // then
    assertThat([self.sut scoreLabel], is(notNilValue()));
}

- (void)testAvatarViewShouldBeConnected
{
    // then
    assertThat([self.sut avatarView], is(notNilValue()));
}

@end
