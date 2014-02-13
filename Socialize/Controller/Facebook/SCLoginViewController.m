//
//  SCLoginViewController.m
//  MyFirstApp
//
//  Created by Helder Lima da Rocha on 10/23/13.
//  Copyright (c) 2013 BEPiD. All rights reserved.
//


#import "SCLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface SCLoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.facebookManager = [FacebookManagerStored sharedInstance];

    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performLogin];
}

- (void)performLogin
{
    if ([self.facebookManager isLoggedIn])
    {
        
        [self.facebookManager login:nil];
        self.facebookManager.isLogedIn = YES;
        [self performSegueWithIdentifier:@"initialTabBarSegue" sender:self];
    }
}

- (IBAction)performLogin:(id)sender
{
    [self.spinner startAnimating];
    
    [self.facebookManager login:^{
        [self.spinner stopAnimating];
        [self performLogin];
        [self performSegueWithIdentifier:@"initialTabBarSegue" sender:self];
    }];
    self.facebookManager.isLogedIn = true;
}



@end
