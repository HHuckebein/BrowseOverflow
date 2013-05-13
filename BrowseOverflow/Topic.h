//
//  Topic.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;
@interface Topic : NSObject

@property (nonatomic, readonly) NSString    *name;
@property (nonatomic, readonly) NSString    *tag;
@property (nonatomic, strong) NSArray       *recentQuestions;

- (id)initWithName:(NSString *)name tag:(NSString *)tag;
- (void)addQuestion:(Question *)question;

@end
