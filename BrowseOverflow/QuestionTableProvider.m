//
//  QuestionTableProvider.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 14.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "QuestionTableProvider.h"
#import "Topic.h"
#import "QuestionSummaryCell.h"
#import "Question.h"
#import "Person.h"

NSString *const questionCellReuseIdentifier = @"QuestionCellStyle";
NSString *const placeholderCellReuseIdentifier = @"BasicStyle";

@interface QuestionTableProvider()
@end

@implementation QuestionTableProvider

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.topic.recentQuestions.count;
    return count ?: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topic.recentQuestions.count) {
        Question *question = self.topic.recentQuestions[indexPath.row];
        QuestionSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:questionCellReuseIdentifier];
        cell.titleLabel.text = question.title;
        cell.scoreLabel.text = [NSNumberFormatter localizedStringFromNumber:@(question.score) numberStyle:NSNumberFormatterDecimalStyle];
        cell.nameLabel.text = question.asker.name;
        
        return cell;
        
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:placeholderCellReuseIdentifier];
        cell.textLabel.text = @"There was a problem connecting to the network";
        
        return cell;
    }
}

#pragma mark - Delegate Part

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

@end
