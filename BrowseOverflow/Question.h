//
//  Question.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AnswerBuilderErrorDomain;

NS_ENUM(NSUInteger, AnswerBuilderError) {
    AnswerBuilderInvalidJSONError,
    AnswerBuilderMissingDataError
};


@class Answer, Person;

@interface Question : NSObject
@property (nonatomic, strong) NSDate            *date;
@property (nonatomic, strong) Person            *asker;
@property (nonatomic, copy  ) NSString          *title;
@property (nonatomic, copy  ) NSString          *body;
@property (nonatomic, strong, readonly) NSArray *answers;

@property (nonatomic, assign) NSInteger         score;
@property (nonatomic, assign) NSInteger         questionID;

- (void)addAnswer:(Answer *)answer;

- (void)fillInDetailsFromJSON:(NSString *)objectNotation;

- (BOOL)addAnswersFromJSON:(NSString *)objectNotation error:(NSError **)error;

- (NSString *)description;
- (NSComparisonResult)compare:(Question *)question;

@end
