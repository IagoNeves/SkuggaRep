//
//  MainMapInfoViewController.m
//  Socialize
//
//  Created by Helder Lima da Rocha on 11/11/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

//DEIXAR CORES MAIS PASTEL NA HORA DE MOSTRAR NA CELL

#import "MainMapInfoViewController.h"
#import "SocializeGroupSpecific.h"

@interface MainMapInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
//- (IBAction)back:(id)sender;

@end

@implementation MainMapInfoViewController
//
//- (IBAction)back:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion: nil]; //isso volta para o ultimo view, pode ser modal
//    //[self.navigationController popViewControllerAnimated:YES]; //nao funciona para modal, funciona automaticamente para push
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 2;
    return [[Singleton singleton].allGroups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSMutableArray *socializeGroups = [Singleton singleton].allGroups;
    NSMutableArray *socializeGroupsSpecific = [Singleton singleton].allGroupsSpecific;
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.editingAccessoryType = YES; //What does this do
    }
    
    SocializeGroup *socializeGroup = socializeGroups[indexPath.row];
    SocializeGroupSpecific *socializeGroupSpecific = socializeGroupsSpecific[indexPath.row];
    
    //cell.textLabel.backgroundColor = socializeGroup.groupAnnotationColor;
    [[cell textLabel] setText: [NSString stringWithFormat: @"%@",socializeGroup.groupName]];
    
    
    
    if(socializeGroupSpecific.isShownOnMap)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_marked.png"]];
    }
    else
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_unmarked.png"]];
    }
    
    [cell.accessoryView setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    cell.backgroundColor = [CustomUIColor darkerColorForColor:socializeGroupSpecific.groupColor];
    
    return cell;
}

/*
 *
 *
 *
 FAZER CLASSE PARA A CUSTOM COLOR PRA PEGAR ESSES MÉTODOS VOMITADOS DE COR (DRKCLR E CHGICN) - (Dark Color e Change Icon)
 *
 *
 */

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *socializeGroups = [Singleton singleton].allGroups;
    NSMutableArray *socializeGroupsSpecific = [Singleton singleton].allGroupsSpecific;
    SocializeGroup *socializeGroup = socializeGroups[indexPath.row];
    SocializeGroupSpecific *socializeGroupSpecific = socializeGroupsSpecific[indexPath.row];
    
    socializeGroupSpecific.isShownOnMap = !socializeGroupSpecific.isShownOnMap;
    if(!socializeGroupSpecific.isShownOnMap)
    {
        [[Singleton singleton].groupsToBeShowOnMap removeObject:socializeGroup];
    }
    else
    {
        [[Singleton singleton].groupsToBeShowOnMap addObject:socializeGroup];
        
        NSArray * sortedArray = [[Singleton singleton].groupsToBeShowOnMap sortedArrayUsingFunction:customSortTwo context:NULL];
        
        [[Singleton singleton].groupsToBeShowOnMap removeAllObjects];
        [Singleton singleton].groupsToBeShowOnMap = [sortedArray mutableCopy];
    }
    [tableView reloadData];
    //UITableViewCell
}

NSInteger customSortTwo(id obj1, id obj2, void *context) {
    SocializeGroup *group1 = (SocializeGroup *) obj1;
    SocializeGroup *group2 = (SocializeGroup *) obj2;
    
    return group1.groupPrecisionRadius > group2.groupPrecisionRadius;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.title = [NSString stringWithFormat:@"Groups shown on Map"];
    
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    // self.navigationItem.leftBarButtonItem = backButton;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
