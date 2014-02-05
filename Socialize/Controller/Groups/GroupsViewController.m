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

@interface GroupsViewController ()

#define alertViewDelete 1

#define groupName 0
#define groupColor 1

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *GroupsNavigationItem;
@property ( nonatomic) NSMutableArray *groups;
@property ( nonatomic) UIImage *GroupImage;
@property ( nonatomic) NSInteger currentRow;

@property (weak, nonatomic) IBOutlet UITableView *groupListTableView;

@property(strong,nonatomic) UIAlertView* popUpWindowDelete;



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
    
    self.groups = [[NSMutableArray alloc]init];
    self.groups[groupName] = [[NSMutableArray alloc]init];
    self.groups [groupColor]= [[NSMutableArray alloc]init];
//this parse code must go somewhere else
    // and also make a db class
    
    

    
    
    
    
    //make protection code in case the column is null for a certain value in the relational table
    PFQuery *groupsQuery = [PFQuery queryWithClassName:@"Groups"];
    //[groupsQuery selectKeys:@[@"groupName", @"groupColor"]];
    [groupsQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
    {
        NSLog(@"%@",error);
        for (PFObject *object in results)
        {
            if ([object objectForKey:@"groupName"])
            {
                [self.groups[groupName] addObject:[object objectForKey:@"groupName"]];
            }
            if ([object objectForKey:@"groupColor"])
            {
                PFFile *colorFile = [object objectForKey:@"groupColor"];
                NSData *colorData = [colorFile getData];
                UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
                [self.groups[groupColor] addObject:color];
            }
            else
            {
                [self.groups[groupColor] addObject:[UIColor whiteColor]];
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:
         ^{
             [self.tableView reloadData];
         }];
    }];
    
  //make dictionary for colors

    
    
    
    
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


//- (IBAction)editGroups:(id)sender
//{
//    [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
//    
//     [self.tableView setEditing:YES animated:YES];
//    
//    
//    
//    //[self.botaoAdd setEnabled:YES];
//    //[self.botaoRelatorio setEnabled:YES];
//    //[self.botaoVenda setEnabled:YES];
//}


- (IBAction)newGroup:(id)sender {
    [self performSegueWithIdentifier:@"newGroupSegue" sender:self];
    
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups[groupName] count];
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

    cell.backgroundColor = self.groups[groupColor][indexPath.row];
  
    
    
    
    [[cell textLabel] setText: [NSString stringWithFormat: @"%@",self.groups[groupName][indexPath.row]]];

    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
{
    self.isSpecificMap = YES;
    self.specificGroupArrayIndex = indexPath.row;
    [self performSegueWithIdentifier:@"specificGroupSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"specificGroupSegue"])
    {
        UINavigationController *destinationViewController = [segue destinationViewController];
        
        ((MainMapViewController *)[destinationViewController  viewControllers][0]).isSpecificMap = self.isSpecificMap;
        
        ((MainMapViewController *)[destinationViewController  viewControllers][0]).specificGroupArrayIndex = self.specificGroupArrayIndex;

        
         //MainMapViewController *destinationViewController = [segue destinationViewController];
        //destinationViewController.isSpecificMap = self.isSpecificMap;

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

@end
