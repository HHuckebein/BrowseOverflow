//
//  QuestionDetailCell.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 21.05.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIWebView *bodyWebView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarView;

@end
