//
//  AnswerBuilder.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 08.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "AnswerBuilder.h"
#import "Question.h"
#import "Answer.h"
#import "Person.h"

NSString *const AnswerBuilderErrorDomain = @"AnswerBuilderErrorDomain";

@implementation AnswerBuilder

- (BOOL)addAnswersToQuestion:(Question *)question fromJSON:(NSString *)objectNotation error:(NSError **)error
{
    NSParameterAssert(objectNotation != nil);
    NSParameterAssert(question != nil);
    
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
            
            [question addAnswer:thisAnswer];
        }

        return TRUE;
        
    }
}

@end
