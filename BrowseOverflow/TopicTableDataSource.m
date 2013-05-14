//
//  TopicTableDataSource.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 13.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "TopicTableDataSource.h"
#import "Topic.h"

NSString *const topicCellReuseIdentifierNotUsedAnymore = @"TopicsCellStyle";

@implementation TopicTableDataSource

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellReuseIdentifierNotUsedAnymore forIndexPath:indexPath];
    cell.textLabel.text = [self topicForIndexPath:indexPath].name;
    
    return cell;
}

@end
