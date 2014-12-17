//
//  QuestionBuilder.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const QuestionBuilderErrorDomain;

NS_ENUM(NSUInteger, QuestionBuilderError) {
    QuestionBuilderInvalidJSONError,
    QuestionBuilderMissingDataError
};

@class Question;

@interface QuestionBuilder : NSObject

- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError **)error;

@end
