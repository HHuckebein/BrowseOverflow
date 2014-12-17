//
//  Question+TestExtension.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 22.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@implementation Question (TestExtension)

- (Answer *)answerWithText:(NSString *)text
{
    NSInteger index = [self.answers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [((Answer *)obj).text isEqualToString:text];
    }];
    
    return index != NSNotFound ? self.answers[index] : nil;
}

@end
