//
//  QuestionTableProvider.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 14.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "QuestionTableProvider.h"

@implementation QuestionTableProvider

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Delegate Part

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

@end
