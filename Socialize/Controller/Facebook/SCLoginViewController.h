//
//  SCLoginViewController.h
//  MyFirstApp
//
//  Created by Helder Lima da Rocha on 10/23/13.
//  Copyright (c) 2013 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"
#import "SCLoginViewController.h"
#import "FacebookManagerStored.h"

@interface SCLoginViewController : UIViewController

@property (nonatomic, strong) FacebookManager *facebookManager;

@end
