//
//  TopicTableDataSource.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 13.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const topicCellReuseIdentifierNotUsedAnymore;

@class Topic;

@interface TopicTableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *topicsList;

- (Topic *)topicForIndexPath:(NSIndexPath *)indexPath;

@end
