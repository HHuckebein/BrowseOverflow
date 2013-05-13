//
//  QuestionBuilder.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "QuestionBuilder.h"
#import "Question.h"
#import "Person.h"

NSString *const QuestionBuilderErrorDomain = @"QuestionBuilderErrorDomain";

@implementation QuestionBuilder

- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError **)error
{
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation
                                                    options:NSJSONReadingAllowFragments
                                                      error:&localError];
    NSDictionary *parsedObject = (id)jsonObject;
    if (nil == parsedObject) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain code:QuestionBuilderInvalidJSONError userInfo:nil];
        }
        return nil;
    }

    NSArray *questions = parsedObject[@"questions"];
    if (nil == questions) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain code:QuestionBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }
    
    NSMutableArray *questionsArray = [NSMutableArray array];
    for (NSDictionary *item in questions) {
        Question *question = [[Question alloc] init];
        if (item[@"question_id"]) {
            question.questionID = [item[@"question_id"] integerValue];
        }
        
        if (item[@"creation_date"]) {
            question.date = [NSDate dateWithTimeIntervalSince1970:[item[@"creation_date"] doubleValue]];
        }
        
        if (item[@"title"]) {
            question.title = item[@"title"];
        }

        if (item[@"score"]) {
            question.score = [item[@"score"] integerValue];
        }

        if (item[@"owner"]) {
            question.asker = [Person personFromOwnerDictionary:item[@"owner"]];
        }
        
        [questionsArray addObject:question];
    }
    
    return [questionsArray copy];
}

@end
