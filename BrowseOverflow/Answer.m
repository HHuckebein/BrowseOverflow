//
//  Answer.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "Answer.h"
#import "Person.h"

@implementation Answer

- (id)init
{
    self = [super init];
    if (self) {
        self.text = @"";
        _accepted = FALSE;
    }
    return self;
}

- (id)initWithText:(NSString *)text score:(NSInteger)score accepted:(BOOL)accepted
{
    if ((self = [self init])) {
        self.text = text;
        _score    = score;
        _accepted = accepted;
    }
    return self;
}
        
- (NSComparisonResult)compare:(Answer *)anotherAnswer
{
    if (self.accepted == anotherAnswer.accepted) {
        return [@(self.score) compare:@(anotherAnswer.score)];
    }
    else {
        return self.accepted ? NSOrderedAscending : NSOrderedDescending;
    }
}

+ (id)answerFromAnswerDictionary:(NSDictionary *)answerDictionary
{
    NSArray *allKeys = [answerDictionary allKeys];
    NSAssert([allKeys containsObject:@"body"], @"Dictionary must contain body key");
    NSAssert([allKeys containsObject:@"score"], @"Dictionary must contain score key");
    NSAssert([allKeys containsObject:@"accepted"], @"Dictionary must contain accepted key");
    
    id newInstance = [[[self class] alloc] initWithText:answerDictionary[@"body"]
                                                  score:[answerDictionary[@"score"] integerValue]
                                               accepted:[answerDictionary[@"accepted"] boolValue]];
    return newInstance;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"TEXT:%@ SCORE:%d PERSON:%@ %@", self.text, self.score, self.person, _accepted ? @"accepted" : @"not accepted"];
}
@end
