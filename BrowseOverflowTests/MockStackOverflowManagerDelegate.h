//
//  MockStackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 17.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"

@interface MockStackOverflowManagerDelegate : NSObject <StackOverflowManagerDelegate>

@property (nonatomic, copy  , readonly) NSError  *fetchedError;
@property (nonatomic, strong, readonly) NSArray  *fetchedQuestions;
@property (nonatomic, strong, readonly) Question *bodyQuestion;
@property (nonatomic, strong, readonly) Question *successQuestion;

- (void)fetchingQuestionsFailedWithError:(NSError *)error;

@end
