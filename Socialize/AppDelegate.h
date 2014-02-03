//
//  AppDelegate.h
//  Socialize
//
//  Created by Iago Neves on 10/22/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SCLoginViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) FBSession *session; //helder
- (void)openSession; //helder

@property (strong, nonatomic) UIWindow *window;

@end
