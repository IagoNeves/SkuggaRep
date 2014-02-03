//
//  GroupInfoViewController.m
//  Socialize
//
//  Created by Helder Lima da Rocha on 11/12/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "Singleton.h"
#import "SocializeGroup.h"
#import "SocializeUser.h"
#import "FacebookManager.h"
#import "CustomUIColor.h"
#import "FacebookManagerStored.h"
#import "CustomUIImage.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MainMapViewController.h"
#import "SocializeGroupSpecific.h"

@interface GroupInfoViewController ()

@property (nonatomic) NSMutableString *myIdentificator;
@property (strong, nonatomic) IBOutlet UIImageView *groupImage;
@property (strong, nonatomic) IBOutlet UIImageView *colorImage;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *notificationField;
@property (strong, nonatomic) IBOutlet UITextField *precisionField;
@property (strong, nonatomic) IBOutlet UILabel *enableLabel;
@property (strong, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) IBOutlet UISwitch *showSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (strong, nonatomic) IBOutlet UIButton *leaveButtonPos;
@property (strong, nonatomic) SocializeGroup *group;
@property (strong, nonatomic) SocializeGroupSpecific *groupSpecific;
@property (strong, nonatomic) FacebookManager *facebookManager;
@property (strong, nonatomic) UIAlertView *alert;
@property (nonatomic) NSUInteger colorIndex;
@property(strong,nonatomic) UIAlertView* popUpWindowDelete;
@property ( nonatomic) NSInteger currentRow;

#define alertViewDelete 3

@end

@implementation GroupInfoViewController

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
    
    self.nameField.delegate = self;
    self.precisionField.delegate = self;
    self.notificationField.delegate = self;
    
    self.facebookManager = [FacebookManagerStored sharedInstance];
    self.group = [Singleton singleton].allGroups[self.groupIndex];
    self.groupSpecific = [Singleton singleton].allGroupsSpecific[self.groupIndex];
    
    [self buildView];
    //[self findColorIndex];
    
    self.nameField.text = self.group.groupName;
    self.precisionField.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.group.groupPrecisionRadius ];
    self.notificationField.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.group.groupWarningRadius];
    self.colorImage.image = [CustomUIImage changeIcon:[UIImage imageNamed:@"circle-grey-top.png"] toColor:self.groupSpecific.groupColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
//
////Muda cor, uma posicao para tras
//- (IBAction)previousColorButton:(id)sender
//{
//    
//    if(!self.colorIndex)
//        self.colorIndex = [[Singleton singleton].padronizedArrayOfColors count];
//    
//    self.colorIndex = (self.colorIndex-1)%([[Singleton singleton].padronizedArrayOfColors count]);
//    
//    self.colorImage.image = [CustomUIImage changeIcon:[UIImage imageNamed:@"circle-grey-top.png"] toColor:[Singleton singleton].padronizedArrayOfColors[self.colorIndex]];
//}
//
////Muda cor, uma posicao para frente
//- (IBAction)nextColorButton:(id)sender {
//    
//    self.colorIndex=(self.colorIndex+1)%[[Singleton singleton].padronizedArrayOfColors count];
//    
//    self.colorImage.image = [CustomUIImage changeIcon:[UIImage imageNamed:@"circle-grey-top.png"] toColor:[Singleton singleton].padronizedArrayOfColors[self.colorIndex]];
//}

//Quando return for apertado no teclado ele ira chamar esse metodo e sumir
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

//- (void)findColorIndex
//{
//    CGFloat hue = 0;
//    CGFloat huePos = 0;
//    UIColor *color = self.groupSpecific.groupColor;
//    NSMutableArray *colorArray = [Singleton singleton].padronizedArrayOfColors;
//    
//    [color getHue:&hue saturation:nil brightness:nil alpha:nil];
//    
//    if(hue == 1)
//        hue = 0;
//    
//    for(int a = 0;a < [colorArray count];a++)
//    {
//        UIColor *posColor = colorArray[a];
//        
//        [posColor getHue:&huePos saturation:nil brightness:nil alpha:nil];
//        
//        if(huePos == 1)
//            huePos = 0;
//        
//        if(hue < huePos){
//            self.colorIndex = a;
//            [colorArray insertObject:color atIndex:a];
//            break;
//        }
//        
//        else if(a == [colorArray count]-1){
//            self.colorIndex = a;
//            [colorArray insertObject:color atIndex:a];
//            break;
//        }
//        
//    }
//    
//}

- (IBAction)leaveGroupButton:(id)sender {
    
    self.alert = [[[UIAlertView alloc]init] initWithTitle: @"Are you sure you want to leave this group?"
                                                  message: @""
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Leave Group", nil];
    self.alert.tag = 1;
    [self.alert show];
    
}

- (IBAction)saveButton:(id)sender {
    
    self.alert = [[[UIAlertView alloc]init] initWithTitle: @"Are you sure you want to save changes?"
                                                  message: @""
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Save", nil];
    self.alert.tag = 2;
    [self.alert show];
    
}

- (void)buildView
{
    NSUInteger numFriend;
    NSUInteger minus;
    
    numFriend = [self.group.usersInTheGroup count];
    
    if(numFriend > 4)
        minus = 0;
    
    else
        minus = (5 - numFriend)*44;
    
    if(numFriend >3)
        self.leaveButtonPos.frame = CGRectMake(116, 569-minus, 88, 30);
    else
        self.leaveButtonPos.frame = CGRectMake(116, 473, 88, 30);
    
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:(CGSizeMake(320, 540-minus))];
    
    self.showLabel.frame = CGRectMake(20, 498-minus, 137, 21);
    self.enableLabel.frame = CGRectMake(20, 537-minus, 68, 21);
    self.showSwitch.frame = CGRectMake(251, 493-minus, 51, 31);
    self.enableSwitch.frame = CGRectMake(251, 532-minus, 51, 31);
    
    
    self.tableView.frame = CGRectMake(0,238,320,240-minus);
    
    [self.tableView reloadData];
}

- (void) alertView:(UIAlertView*) alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex==1)
        {
            [FBRequestConnection startForMeWithCompletionHandler:
             ^(FBRequestConnection *connection, id result, NSError *error)
             {
                 self.myIdentificator = result[@"id"];
             }];
            
            [self.group removeUserInTheGroup:self.myIdentificator];
            [[Singleton singleton].allGroups removeObjectAtIndex:self.groupIndex];
            
            MainMapViewController *view = [self.navigationController viewControllers][0];
            view.goToGroupView = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            
       //     [self.group updateGroupInformationWithName: self.nameField.text
                                  //       warningRadius: [self.notificationField.text intValue] precisionRadius: [self.precisionField.text intValue] willBeShownOnMap:self.showSwitch.on andEnable: self.enableSwitch.on];
            [self.group updateGroupInformationWithName:self.nameField.text warningRadius:[self.notificationField.text intValue] precisionRadius:[self.precisionField.text intValue]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag==alertViewDelete)
    {
        if (buttonIndex==0)
        {
            
        }
        if (buttonIndex==1)
        {
            // [self.groupUsers removeObjectAtIndex: self.currentRow-2];
            [self.group.usersInTheGroup removeObjectAtIndex: self.currentRow];
            [self.tableView reloadData];
            //LEMBRETE: if (self.group.usersInTheGroup == 1) { deleteTheWholeFuckingGroup}
            //nao implemento isso agora porque essa classe ainda esta muito inacabada e apresenta varios erros "Iago"
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    
 //   [[Singleton singleton].padronizedArrayOfColors removeObjectAtIndex:self.colorIndex];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentRow=indexPath.row;
    self.popUpWindowDelete = [[[UIAlertView alloc]init] initWithTitle: @"Do you want to remove this user?"
                                                              message: @""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Remove User", nil];
    self.popUpWindowDelete.tag = alertViewDelete;
    [self.popUpWindowDelete show];
}
#pragma mark - tableViewDataSource

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.group.usersInTheGroup count];
    
}

#pragma mark - tableViewDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    SocializeUser* user = (SocializeUser*) self.group.usersInTheGroup[indexPath.row];
    NSURL * imageURL = [NSURL URLWithString: user.photo];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [cell.imageView setImage:image];
    
    cell.textLabel.text = user.name;
    
    return cell;
}

@end