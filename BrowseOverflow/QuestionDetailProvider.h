//
//  QuestionDetailProvider.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 21.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const questionDetailCellReuseIdentifier;
extern NSString *const answerCellReuseIdentifier;

@class Question;
@interface QuestionDetailProvider : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Question *question;

@end
