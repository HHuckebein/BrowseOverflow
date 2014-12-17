//
//  BrowseOverflow - QuestionDetailCellTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "QuestionDetailCell.h"

    // Collaborators
#import "BrowseOverflowViewController.h"
#import "QuestionDetailProvider.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface QuestionDetailCellTest : SenTestCase
@property (nonatomic, strong) QuestionDetailCell *sut;
@end

@implementation QuestionDetailCellTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BrowseOverflowViewController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BrowseOverflowViewController class])];
    [controller view];
    
    self.sut = [controller.tableView dequeueReusableCellWithIdentifier:questionDetailCellReuseIdentifier];
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

- (void)testBodyWebViewShouldBeConnected
{
    assertThat([self.sut bodyWebView], is(notNilValue()));
}

@end
