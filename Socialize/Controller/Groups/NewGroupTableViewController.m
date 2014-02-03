//
//  NewGroupTableViewController.m
//  Socialize
//
//  Created by Iago Neves on 10/29/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "NewGroupTableViewController.h"
#import "ContactsTableViewController.h"
#import "GroupSettingViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface NewGroupTableViewController ()

#define alertViewDelete 1

//@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) UITextField *groupNameTextField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property(strong,nonatomic) UIAlertView* popUpWindowDelete;

@property ( nonatomic) NSInteger currentRow;

//@property (weak, nonatomic) UIButton *deleteButton;

@end

@implementation NewGroupTableViewController
- (IBAction)next:(id)sender
{
    [self performSegueWithIdentifier:@"toGroupSettingsSegue" sender:self];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.groupTitle = [[NSMutableString alloc]init];
    
    
    
    //    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //    [self.tableView addGestureRecognizer:gestureRecognizer];
    
}

//- (void) hideKeyboard {
//    [self.groupNameTextField resignFirstResponder];
//}
//
//- (void)dismissKeyboard
//{
//    [self.groupNameTextField resignFirstResponder];
//}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupUsers count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int row = indexPath.row;
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if (indexPath.section==0 && indexPath.row==0)
    {
        [[cell textLabel] setText:@"Group's name:"];
        self.groupNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 10, 185, 30)];
        self.groupNameTextField.delegate = self;
        self.groupNameTextField.adjustsFontSizeToFitWidth = YES;
        self.groupNameTextField.textColor = [UIColor blackColor];
        self.groupNameTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        self.groupNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        self.groupNameTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // playerTextField.placeholder = (![self.groupMember isEqualToString:@""]) ? self.groupMember : @"email@email.com";
        //playerTextField.placeholder = @"Bro's";
        self.groupNameTextField.keyboardType = UIKeyboardTypeAlphabet;
        // self.groupNameTextField.returnKeyType = UIReturnKeyDone;
        
        [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [cell.contentView addSubview:self.groupNameTextField];
        
        //Desativa selecao da celula
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    else if (indexPath.section==0 && indexPath.row==1)
    {
        [[cell textLabel] setText:@"Members:"];
        UILabel *groupMembersLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        groupMembersLabel.text=self.groupMember.name;
        [cell.contentView addSubview:groupMembersLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(addbuttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //Desativa selecao da celula
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        SocializeUser *socializeUser = self.groupUsers[row-2];
        NSURL * imageURL = [NSURL URLWithString: [NSString stringWithString:socializeUser.photo]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        cell.imageView.image = image;
        [[cell textLabel] setText: [NSString stringWithFormat: @"%@",socializeUser.name]];
        
        //        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [deleteButton setBackgroundImage: [UIImage imageNamed:@"DeleteButton"] forState:UIControlStateNormal];
        //       // deleteButton.backgroundColor = [UIColor redColor];
        //         [deleteButton addTarget:self action:@selector(deleteGroupMember:) forControlEvents:UIControlEventTouchUpInside];
        //        deleteButton.frame = CGRectMake(110, 10, 30, 30);
        //        cell.accessoryView = deleteButton;
        
    }
    return cell;
}

-(void)textFieldDidChange :(UITextField *)theTextField
{
    //NSLog( @"text changed: %@", theTextField.text);
    self.groupTitle = [self.groupNameTextField.text copy];
    if ([self.groupTitle length]>0 && [self.groupUsers count]>0)
    {
        [self.nextButton setEnabled:YES];
    }
    else
    {
        [self.nextButton setEnabled:NO];
    }
}

/*
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [self.view endEditing:YES];
 }
 */

- (void) addbuttonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"selectUserFromContactList" sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // NSLog(@"GROUP MEMBER: %@", self.groupMember);
    [self.nextButton setEnabled: NO];
    if (!self.groupUsers)
    {
        self.groupUsers = [[NSMutableArray alloc]init];
    }
    else
    {
        BOOL add = YES;
        
        for(SocializeUser *user in self.groupUsers)
        {
            if(user.identificator == self.groupMember.identificator)
            {
                add = NO;
                break;
            }
        }
        if(add)
        {
            [self.groupUsers addObject:self.groupMember];
        }
        
        self.groupMember=nil;
    }
    
    if ([self.groupTitle length]>0 && [self.groupUsers count]>0)
    {
        [self.nextButton setEnabled:YES];
    }
    
    [self.tableView reloadData];
}

//- (IBAction)backButton:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectUserFromContactList"]) {
        UITabBarController *destinationViewController = [segue destinationViewController];
        
        self.groupMember = [SocializeUser alloc];
        ((ContactsTableViewController *)[[destinationViewController viewControllers][1] viewControllers][0]).isSelectingUsers = YES;
        ((ContactsTableViewController *)[[destinationViewController viewControllers][1] viewControllers][0]).groupMember = self.groupMember;
        
        //Exibe a ContactViewController
        [destinationViewController setSelectedIndex:1];
        
        //E se em vez de mandar para o tab bar controller, depois para o navigation view controller, para so depois ir para o view controller certo, que tal apenas ir navigation view controller -> navigation certo. Não precisa ir para o tab bar controller "Iago"
        
        
    }
    if ([[segue identifier] isEqualToString:@"toGroupSettingsSegue"])
    {
        GroupSettingViewController *destinationViewController = [segue destinationViewController];
        
        destinationViewController.groupTitle = self.groupTitle;
        destinationViewController.groupUsers = self.groupUsers;
        
    }
}


- (void) alertView:(UIAlertView*) alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==alertViewDelete)
    {
        if (buttonIndex==0)
        {
            
        }
        if (buttonIndex==1)
        {
            [self.groupUsers removeObjectAtIndex: self.currentRow-2];
            [self.tableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 2)
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
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */
/*
 -(BOOL) textFieldShouldReturn:(UITextField *)textField
 {
 [textField resignFirstResponder];
 [self.groupTitle stringByAppendingString: textField.text];
 //[self.groupTitle stringByAppendingString:playerTextField.text];
 
 return YES;
 }
 
 -(void)dismissKeyboard: (UITextField *)textField
 {
 [textField resignFirstResponder];
 [self.groupTitle stringByAppendingString: textField.text];
 
 }
 */

@end
