//
//  AnswerCell.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 21.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel        *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel        *acceptedIndicator;
@property (nonatomic, weak) IBOutlet UILabel        *personName;
@property (nonatomic, weak) IBOutlet UIImageView    *personAvatar;
@property (nonatomic, weak) IBOutlet UIWebView      *bodyWebView;

- (NSString *)description;

@end
