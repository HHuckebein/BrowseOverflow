//
//  Question.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "Question.h"
#import "Person.h"
#import "Answer.h"

NSString *const AnswerBuilderErrorDomain = @"AnswerBuilderErrorDomain";

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

- (BOOL)addAnswersFromJSON:(NSString *)objectNotation error:(NSError **)error
{
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
    NSDictionary *answerData = [NSJSONSerialization JSONObjectWithData:unicodeNotation options: 0  error: &localError];
    if (answerData == nil) {
        if (error) {
            if (localError != nil) {
                *error = [NSError errorWithDomain:AnswerBuilderErrorDomain
                                             code:AnswerBuilderInvalidJSONError
                                         userInfo:@{NSUnderlyingErrorKey : localError}];
            }
            return FALSE;
        }
        return FALSE;
    }
    else {
        NSArray *answers = answerData[@"answers"];
        if (nil == answers) {
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain code:AnswerBuilderMissingDataError userInfo:nil];
            return FALSE;
            
        }
        
        for (NSDictionary *answerDict in answers) {
            Answer *thisAnswer = [Answer answerFromAnswerDictionary:answerDict];
            
            NSDictionary *ownerDict = answerDict[@"owner"];
            thisAnswer.person = [Person personFromOwnerDictionary:ownerDict];
            
            [self addAnswer:thisAnswer];
        }
        
        return TRUE;
        
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"TITLE:%@ (ID:%d) DATE:%@ S:%d BODY:%@ ASKER:%@, ANSWERS:%@", self.title, self.questionID, self.date, self.score, self.body, self.answers, self.asker];
}

- (NSComparisonResult)compare:(Question *)question
{
    NSComparisonResult result = NSOrderedAscending;
    if (self.questionID == question.questionID) {
        result = NSOrderedSame;
    }
    else if (self.questionID > question.questionID) {
        result = NSOrderedDescending;
    }
        
    return  result;
}

@end
