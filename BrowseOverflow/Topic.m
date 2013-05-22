//
//  Topic.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "Topic.h"
#import "Question.h"

@interface Topic()
@end

@implementation Topic

- (id)initWithName:(NSString *)name tag:(NSString *)tag
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _tag = [tag copy];
    }
    return self;
}

- (void)addQuestion:(Question *)question
{
    if ([self containsQuestion:question] == FALSE) {
        NSArray *array = [[self.recentQuestions arrayByAddingObject:question] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((Question *)obj2).date compare:((Question *)obj1).date];
        }];
        
        self.recentQuestions = array.count > 20 ? [array subarrayWithRange:NSMakeRange(0, 20)] : array;
    }
}

- (NSArray *)recentQuestions
{
    if (nil == _recentQuestions) {
        _recentQuestions = [NSArray array];
    }
    return _recentQuestions;
}

- (BOOL)containsQuestion:(Question *)question
{
    NSUInteger index = [self.recentQuestions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [(Question *)obj compare:question] == NSOrderedSame;
    }];
    
    if (index == NSNotFound) {
        return FALSE;
    }
    else {
        return TRUE;
    }
}

@end
