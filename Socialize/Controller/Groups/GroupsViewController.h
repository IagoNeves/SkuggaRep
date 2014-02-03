//
//  GroupsViewController.h
//  Socialize
//
//  Created by Iago Neves on 10/23/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIColor.h"

@interface GroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSInteger specificGroupArrayIndex;

@property (nonatomic) bool isSpecificMap;

- (IBAction) EditTable:(id)sender;

@end
