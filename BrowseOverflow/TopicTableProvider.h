//
//  TopicTableProvider.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 14.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const topicCellReuseIdentifier;
extern NSString *const TopicTableDidSelectTopicNotification;

@class Topic;

@interface TopicTableProvider : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *topicsList;

@end
