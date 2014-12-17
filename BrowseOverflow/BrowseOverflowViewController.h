//
//  MasterViewController.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackOverflowManagerDelegate.h"

@interface BrowseOverflowViewController : UIViewController <StackOverflowManagerDelegate>

@property (nonatomic, weak  ) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSObject <UITableViewDataSource, UITableViewDelegate> *provider;

@end
