//
//  GroupInfoViewController.h
//  Socialize
//
//  Created by Helder Lima da Rocha on 11/12/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSUInteger groupIndex;

@end
