//
//  GroupsViewController.m
//  Socialize
//
//  Created by Iago Neves on 10/23/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "GroupsViewController.h"
#import "Singleton.h"
#import "SocializeGroup.h"
#import "MainMapViewController.h"
#import <Parse/Parse.h>
#import "DAOParse.h"

@interface GroupsViewController () <DAOParseDelegate>

#define alertViewDelete 1

#define groupNameEnum 0
#define groupColorEnum 1

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *GroupsNavigationItem;
@property ( nonatomic) NSMutableArray *allGroups;
@property ( nonatomic) NSMutableArray *usersInTheGroup;

@property ( nonatomic) UIImage *GroupImage;
@property ( nonatomic) NSInteger currentRow;

@property (weak, nonatomic) IBOutlet UITableView *groupListTableView;

@property(strong,nonatomic) UIAlertView* popUpWindowDelete;

@property (nonatomic) NSString *specificGroupName;


@property ( nonatomic) NSInteger counterWasBetMade;

- (IBAction)newGroup:(id)sender;
@end

@implementation GroupsViewController

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

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    

    NSString *class = @"Groups";
    NSMutableArray *ArrayOfColumns = [[NSMutableArray alloc]init];
    ArrayOfColumns[groupNameEnum] = @"groupName";
    ArrayOfColumns[groupColorEnum] = @"groupColor";
    DAOParse *daoParse;
    daoParse = [[DAOParse alloc]init];
    daoParse.delegate = self;
    [daoParse fetchAllValuesOfClass:class andColumns:ArrayOfColumns];
    
    
    

    
    
    
  //make dictionary for colors ? /??
    //doesn't dismiss viewcontroller unless the image is loaded
    //small gap between rows: change design
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self GroupsNavigationItem ];
    [self navigationItem] ;
    [self.groupListTableView reloadData];
    
    if ([[Singleton singleton].allGroups count]==0)
    {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    else
    {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)newGroup:(id)sender
{
    [self performSegueWithIdentifier:@"newGroupSegue" sender:self];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.allGroups count])
    {
        return [self.allGroups[groupNameEnum] count];
    }
    else
    {
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    NSMutableArray *socializeGroups = [Singleton singleton].allGroups;
//    NSMutableArray *socializeGroupsSpecific = [Singleton singleton].allGroupsSpecific;
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.editingAccessoryType = YES;
    }
    
    
//    SocializeGroup *socializeGroup = socializeGroups[indexPath.row];
//    SocializeGroupSpecific *socializeGroupSpecific = socializeGroupsSpecific[indexPath.row];
//    [[cell textLabel] setText: [NSString stringWithFormat: @"%@",socializeGroup.groupName]];

    //cell.backgroundColor = [CustomUIColor darkerColorForColor:self.groupColors];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.accessoryView setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    cell.backgroundColor = self.allGroups[groupColorEnum][indexPath.row];
    [[cell textLabel] setText: [NSString stringWithFormat: @"%@",self.allGroups[groupNameEnum][indexPath.row]]];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
{

//    NSString *groupTitle = self.allGroups[groupNameEnum][indexPath.row];
//    NSMutableArray *ArrayOfColumns = [[NSMutableArray alloc]init];
//    ArrayOfColumns[0] = @"name";
//    DAOParse *daoParse;
//    daoParse = [[DAOParse alloc]init];
//    daoParse.delegate = self;
//    [daoParse fetchAllUsersInGroup:groupTitle];
    
    self.isSpecificMap = YES;
    self.specificGroupArrayIndex = indexPath.row;
    self.specificGroupName = self.allGroups[groupNameEnum][indexPath.row];
    
  

   [self performSegueWithIdentifier:@"specificGroupSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"specificGroupSegue"])
    {
        UINavigationController *destinationViewController = [segue destinationViewController];
        
        ((MainMapViewController *)[destinationViewController  viewControllers][0]).isSpecificMap = self.isSpecificMap;
        
        ((MainMapViewController *)[destinationViewController  viewControllers][0]).specificGroupArrayIndex = self.specificGroupArrayIndex;
        
        ((MainMapViewController *)[destinationViewController  viewControllers][0]).groupName = self.specificGroupName;

    }
}


- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}



// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.currentRow = indexPath.row;
        self.popUpWindowDelete = [[[UIAlertView alloc]init] initWithTitle: @"Are you sure you want to delete this group?"
                                                                  message: @""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"Delete Group", nil];
        self.popUpWindowDelete.tag = alertViewDelete;
        [self.popUpWindowDelete show];

        
    }
}


// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath)
    {
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
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
            for (int i=0; i<[[Singleton singleton].groupsToBeShowOnMap count]; i++)
            {
                if ([Singleton singleton].groupsToBeShowOnMap[i] == [Singleton singleton].allGroups[self.currentRow])
                {
                    [[Singleton singleton].groupsToBeShowOnMap removeObjectAtIndex: i];
                }
            }
            [[Singleton singleton].allGroups removeObjectAtIndex: self.currentRow];
            [[Singleton singleton].allGroupsSpecific removeObjectAtIndex: self.currentRow];
            [self.tableView reloadData];
        }
    }
}

-(void)hasCompletedGroupColumnsDataFetch:(NSMutableArray *)resultsArray
{
    self.allGroups = resultsArray;
    [self.tableView reloadData];
}

//-(void)hasCompletedGroupUsersDataFetch:(NSMutableArray *)resultsArray
//{
//    self.usersInTheGroup = resultsArray;
//    [self.tableView reloadData];
//}


@end
