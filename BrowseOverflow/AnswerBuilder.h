//
//  AnswerBuilder.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 08.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AnswerBuilderErrorDomain;

NS_ENUM(NSUInteger, AnswerBuilderError) {
    AnswerBuilderInvalidJSONError,
    AnswerBuilderMissingDataError
};

@class Question;
@interface AnswerBuilder : NSObject

- (BOOL)addAnswersToQuestion:(Question *)question fromJSON: (NSString *)objectNotation error: (NSError **)error;

@end
