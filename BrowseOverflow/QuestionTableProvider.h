//
//  QuestionTableProvider.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 14.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const questionCellReuseIdentifier;
extern NSString *const placeholderCellReuseIdentifier;

@class Topic;
@interface QuestionTableProvider : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Topic *topic;

@end
