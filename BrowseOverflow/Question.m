//
//  Question.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "Question.h"

@interface Question()
@property (nonatomic, strong) NSMutableSet *answerSet;
@end

@implementation Question

- (id)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
    }
    return self;
}

- (NSArray *)answers
{
    return [[self.answerSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

- (void)addAnswer:(Answer *)answer
{
    [self.answerSet addObject:answer];
}

- (NSMutableSet *)answerSet
{
    if (nil == _answerSet) {
        _answerSet = [NSMutableSet set];
    }
    return _answerSet;
}

- (void)fillInDetailsFromJSON:(NSString *)objectNotation
{
    NSParameterAssert(objectNotation != nil);

    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options: 0 error: NULL];
    
    if (nil == parsedObject || ![parsedObject isKindOfClass: [NSDictionary class]]) {
        return;
    }
    
    NSString *questionBody = [parsedObject[@"questions"] lastObject][@"body"];
    if (questionBody) {
        self.body = questionBody;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"TITLE:%@ (ID:%d) DATE:%@ S:%d BODY:%@ ASKER:%@, ANSWERS:%@", self.title, self.questionID, self.date, self.score, self.body, self.answers, self.asker];
}

@end
