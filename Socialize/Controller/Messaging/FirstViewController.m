//
//  FirstViewController.m
//  Socialize
//
//  Created by Iago Neves on 10/22/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messagesTextView;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"txt"];
    self.messagesTextView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
