//
//  NewGroupTableViewController.h
//  Socialize
//
//  Created by Iago Neves on 10/29/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeUser.h"

@interface NewGroupTableViewController : UITableViewController <UITextFieldDelegate>


@property (nonatomic, strong) SocializeUser *groupMember;

@property (nonatomic, strong) NSMutableArray *groupUsers;

@property(nonatomic, strong) NSMutableString *groupTitle;


@end
