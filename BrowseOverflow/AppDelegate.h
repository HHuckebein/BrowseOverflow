//
//  AppDelegate.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseOverflowDelegate.h"

@class StackOverflowManager, AvatarStore;

@interface AppDelegate : UIResponder <UIApplicationDelegate, BrowseOverflowDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
