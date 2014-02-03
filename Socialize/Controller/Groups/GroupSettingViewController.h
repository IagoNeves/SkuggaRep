//
//  GroupSettingViewController.h
//  Socialize
//
//  Created by Lucas Mageste on 10/29/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "SocializeGroup.h"
#import "CustomUIImage.h"
#import "ColorPickerView.h"

@interface GroupSettingViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *groupUsers;

@property(nonatomic, strong) NSString *groupTitle;
@property (weak, nonatomic) IBOutlet ColorPickerView *colorPicker;


@end
