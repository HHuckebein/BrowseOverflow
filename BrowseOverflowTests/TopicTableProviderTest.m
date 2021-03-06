//
//  BrowseOverflow - TopicTableProviderTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "TopicTableProvider.h"

    // Collaborators
#import "Topic.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface TopicTableProviderTest : SenTestCase
@property (nonatomic, strong) TopicTableProvider    *sut;
@property (nonatomic, strong) UITableView           *mockTableView;

@property (nonatomic, strong) Topic                 *receivedTopic;
@property (nonatomic, assign) NSInteger             didSelectTopicCount;
@end

@implementation TopicTableProviderTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.sut = [[TopicTableProvider alloc] init];
    
    self.mockTableView = mock([UITableView class]);
    
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    self.sut.topicsList = @[topic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectTopic:) name:TopicTableDidSelectTopicNotification object:nil];
}

- (void)tearDown
{
    _sut = nil;
    _mockTableView = nil;
    _receivedTopic = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super tearDown];
}

- (void)testTopicsListContainsOneEntry
{
    assertThat(self.sut.topicsList, hasCountOf(1));
}

- (void)testTopicsListContainsTwoEntries
{
    // given
    Topic *topicOne = [[Topic alloc] initWithName:@"Mac OS X" tag:@"macosx"];
    Topic *topicTwo = [[Topic alloc] initWithName:@"Cocoa" tag:@"cocoa"];
    
    // when
    self.sut.topicsList = @[topicOne, topicTwo];
    
    // then
    assertThat(self.sut.topicsList, hasCountOf(2));
}

- (void)testThrowsExceptionWhenAskedForNumberOfRowsInSectionOne
{
    STAssertThrows([self.sut tableView:nil numberOfRowsInSection:1], @"TopicTableDataSource doesn't support more than one section");
}

- (void)testThrowsExceptionWhenAskedFor
{
    STAssertThrows([self.sut tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]], @"TopicTableDataSource doesn't support more than one section");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasTopics
{
    STAssertThrows([self.sut tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.sut.topicsList.count inSection:0]], @"IndexPath.row must within the bounds of the topicsList");
}

- (void)testCellCreatedByDataSourceContainsTopicTitleAsTextLabel
{
    // given
    UITableViewCell *topicsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:topicCellReuseIdentifier];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [given([self.mockTableView dequeueReusableCellWithIdentifier:topicCellReuseIdentifier forIndexPath:indexPath]) willReturn:topicsCell];
    
    // when
    UITableViewCell *cell = [self.sut tableView:self.mockTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // then
    assertThat(cell.textLabel.text, is(equalTo(@"iPhone")));
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

- (void)testTopicDelegateShouldSendNotificationWithTopicObject
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    Topic *topic = self.sut.topicsList[0];
    
    [given([self.mockTableView dataSource]) willReturn:self.sut];
    
    // when
    [self.sut tableView:self.mockTableView didSelectRowAtIndexPath:indexPath];
    
    // then
    assertThat(self.receivedTopic, is(equalTo(topic)));
}

- (void)didSelectTopic:(NSNotification *)notification
{
    self.receivedTopic = (Topic *)[notification object];
    ++_didSelectTopicCount;
}

@end
