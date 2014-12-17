//
//  AnswerCell.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 21.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"NAME:%@ SCORE:%@ %@", self.personName.text, self.scoreLabel.text, self.acceptedIndicator.hidden? @"not accepted" : @"accepted"];
}

@end
