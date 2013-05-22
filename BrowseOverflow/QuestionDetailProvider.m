//
//  QuestionDetailProvider.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 21.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "QuestionDetailProvider.h"
#import "AppDelegate.h"
#import "QuestionDetailCell.h"
#import "Question.h"
#import "Person.h"
#import "AvatarStore.h"
#import "AnswerCell.h"
#import "Answer.h"

typedef NS_ENUM(NSUInteger, SectionIdentifier) {
    SectionIdentifierQuestion,
    SectionIdentifierAnswer,
    SectionIdentifierMax
};

NSString *const questionDetailCellReuseIdentifier = @"QuestionDetailCellStyle";
NSString *const answerCellReuseIdentifier = @"AnswerCellStyle";

@implementation QuestionDetailProvider

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == SectionIdentifierAnswer? self.question.answers.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionIdentifier secIdentifier = indexPath.section;
    
    switch (secIdentifier) {
        case SectionIdentifierQuestion:
        {
            QuestionDetailCell *cell = (QuestionDetailCell *)[tableView dequeueReusableCellWithIdentifier:questionDetailCellReuseIdentifier];
            cell.titleLabel.text = self.question.title;
            cell.nameLabel.text = self.question.asker.name;
            cell.scoreLabel.text = [NSNumberFormatter localizedStringFromNumber:@(self.question.score) numberStyle:NSNumberFormatterDecimalStyle];
            [cell.bodyWebView loadHTMLString:[self HTMLStringForSnippet:self.question.body] baseURL:nil];
            
            NSData *avatarData = [[[self appDelegate] avatarStore] dataForURL:self.question.asker.avatarURL];
            if (nil == avatarData) {
                avatarData = [[[self appDelegate] avatarStore] defaultData];
            }
            cell.avatarView.image = [UIImage imageWithData:avatarData];
            
            return cell;
        }
            break;
            
        case SectionIdentifierAnswer:
        {
            Answer *answer = self.question.answers[indexPath.row];
            
            AnswerCell *cell = (AnswerCell *)[tableView dequeueReusableCellWithIdentifier:answerCellReuseIdentifier];
            cell.scoreLabel.text = [NSNumberFormatter localizedStringFromNumber:@(answer.score) numberStyle:NSNumberFormatterDecimalStyle];
            cell.acceptedIndicator.hidden = !answer.accepted;
            
            Person *person = answer.person;
            cell.personName.text = person.name;
            cell.personAvatar.image = [UIImage imageWithData:[[[self appDelegate] avatarStore] dataForURL:person.avatarURL]];
            [cell.bodyWebView loadHTMLString:[self HTMLStringForSnippet:answer.text] baseURL:nil];
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSString *)HTMLStringForSnippet:(NSString *)snippet
{
    return [NSString stringWithFormat:@"<html><head></head><body>%@</body></html>", snippet];
}

#pragma mark - Delegate Part

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.;
    switch (indexPath.section) {
        case SectionIdentifierQuestion:
            height = 256.;
            break;
            
        case SectionIdentifierAnswer:
            height = 200.;
            break;
            
        default:
            break;
    }
    
    return height;
}

#pragma mark - AppDelegate

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
