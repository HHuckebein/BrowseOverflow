//
//  Question+TestExtension.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 22.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "Answer.h"

@interface Question (TestExtension)

- (Answer *)answerWithText:(NSString *)text;

@end
