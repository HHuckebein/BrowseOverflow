//
//  BrowseOverflow - TopicTableDelegateTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "TopicTableDelegate.h"

    // Collaborators
#import "TopicTableDataSource.h"
#import "Topic.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface TopicTableDelegateTest : SenTestCase
@property (nonatomic, strong) TopicTableDelegate *sut;
@property (nonatomic, strong) TopicTableDataSource *mockTopicDataSource;

@property (nonatomic, strong) Topic *receivedTopic;

@property (nonatomic, assign) NSInteger didSelectTopicCount;

@end

@implementation TopicTableDelegateTest
{
    // test fixture ivars go here
}


- (void)setUp
{
    [super setUp];
    self.sut = [[TopicTableDelegate alloc] init];
    self.mockTopicDataSource = mock([TopicTableDataSource class]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectTopic:) name:TopicTableDidSelectTopicNotificationNotUsedAnymore object:nil];
}

- (void)tearDown
{
    _sut = nil;
    _mockTopicDataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super tearDown];
}

- (void)testDidSelectRowAtIndexPathPostsNotificationWithTopicObject
{
    // given
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // when
    [self.sut tableView:nil didSelectRowAtIndexPath:indexPath];
    
    // then
    assertThatInteger(_didSelectTopicCount, is(equalToInteger(1)));
}

- (void)testTopicDelegateShouldKeepIndexPath
{
    // given
    UITableView *mockTableView = mock([UITableView class]);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    
    [given([mockTableView dataSource]) willReturn:self.mockTopicDataSource];
    [given([self.mockTopicDataSource topicForIndexPath:indexPath]) willReturn:topic];
    
    // when
    [self.sut tableView:mockTableView didSelectRowAtIndexPath:indexPath];
    
    // then
    assertThat(self.receivedTopic, is(equalTo(topic)));
}

- (void)didSelectTopic:(NSNotification *)notification
{
    self.receivedTopic = (Topic *)[notification object];
    ++_didSelectTopicCount;
}

@end
