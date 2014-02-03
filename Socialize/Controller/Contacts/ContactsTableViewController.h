//
//  ContactsController.h
//  MyFirstApp
//
//  Created by Helder Lima da Rocha on 10/28/13.
//  Copyright (c) 2013 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainMapViewController.h"
#import "FacebookManager.h"
#import "FacebookManagerStored.h"
#import "SocializeUser.h"

@interface ContactsTableViewController :  UIViewController <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL isSelectingUsers;


@property (nonatomic, strong) SocializeUser *groupMember;

@property (nonatomic, strong) NSMutableArray *groupMembersArray;



@end
