//
//  AppDelegate.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StackOverflowManager, AvatarStore;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) StackOverflowManager *manager;
@property (nonatomic, strong) AvatarStore *avatarStore;

@end
