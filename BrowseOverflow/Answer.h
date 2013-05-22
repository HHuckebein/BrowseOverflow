//
//  Answer.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface Answer : NSObject
@property (nonatomic, copy  ) NSString                  *text;
@property (nonatomic, strong) Person                    *person;
@property (nonatomic, assign) NSInteger                 score;
@property (nonatomic, assign, getter = isAccepted) BOOL accepted;

+ (id)answerFromAnswerDictionary:(NSDictionary *)answerDictionary;

- (NSComparisonResult)compare:(Answer *)anotherAnswer;
- (NSString *)description;

@end
