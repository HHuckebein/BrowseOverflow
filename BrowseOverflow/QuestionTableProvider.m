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
#import "AppDelegate.h"
#import "AvatarStore.h"

NSString *const QuestionTableDidSelectQuestionNotification = @"QuestionTableDidSelectQuestionNotification";
NSString *const questionCellReuseIdentifier = @"QuestionCellStyle";
NSString *const placeholderCellReuseIdentifier = @"BasicStyle";

@interface QuestionTableProvider()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation QuestionTableProvider

#pragma mark - AppDelegate

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarStoreDidUpdateContent:) name:AvatarStoreDidUpdateContentNotification object:[self appDelegate].avatarStore];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)avatarStoreDidUpdateContent:(NSNotification *)notification
{
    [self.tableView reloadData];
}

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
        
        NSData *avatarData = [[[self appDelegate] avatarStore] dataForURL:question.asker.avatarURL];
        if (nil == avatarData) {
            avatarData = [[[self appDelegate] avatarStore] defaultData];
        }
        cell.avatarView.image = [UIImage imageWithData:avatarData];
        
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
    if ([self.topic recentQuestions].count) {
        NSNotification *notification = [NSNotification notificationWithName: QuestionTableDidSelectQuestionNotification object:self.topic.recentQuestions[indexPath.row]];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topic.recentQuestions.count ? 80. : 44.;
}

@end
