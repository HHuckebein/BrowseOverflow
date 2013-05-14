//
//  TopicTableProvider.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 14.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "TopicTableProvider.h"
#import "Topic.h"

NSString *const topicCellReuseIdentifier = @"TopicsCellStyle";
NSString *const TopicTableDidSelectTopicNotification = @"TopicTableDidSelectTopicNotification";

@implementation TopicTableProvider

#pragma mark - DataSource Part

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    
    return self.topicsList.count;
}

- (Topic *)topicForIndexPath:(NSIndexPath *)indexPath
{
    return self.topicsList[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < self.topicsList.count);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self topicForIndexPath:indexPath].name;
    
    return cell;
}

#pragma mark - Delegate Part

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    Topic *topic = [(TopicTableProvider *)tableView.dataSource topicForIndexPath:indexPath];
    NSNotification *notification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:topic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
