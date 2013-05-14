//
//  TopicTableDelegate.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 13.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "TopicTableDelegate.h"
#import "TopicTableDataSource.h"

NSString *const TopicTableDidSelectTopicNotificationNotUsedAnymore = @"TopicTableDidSelectTopicNotification";

@interface TopicTableDelegate()
@end

@implementation TopicTableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    Topic *topic = [(TopicTableDataSource *)tableView.dataSource topicForIndexPath:indexPath];
    NSNotification *notification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotificationNotUsedAnymore object:topic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
