//
//  GroupSettingViewController.m
//  Socialize
//
//  Created by Lucas Mageste on 10/29/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "GroupSettingViewController.h"
#import "SocializeUser.h"
#import "SocializeGroupSpecific.h"
#import <Parse/Parse.h>

//Se voce colocar Proximity Notification como "x" ele está salvando como "x-1". "Iago"

@interface GroupSettingViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *warningRadiusLabel;
@property (weak, nonatomic) IBOutlet UISlider *warningRadiusSlider;
@property (weak, nonatomic) IBOutlet UISwitch *selectIfGroupIsWillBeShownOnTheMapLabel;
@property (weak, nonatomic) IBOutlet UISlider *groupPrecisionRadiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *groupPrecisionRadiusLabel;
@property (nonatomic) bool addCurrentGroupToMainMap;
@property (strong, nonatomic) IBOutlet UIImageView *colorImage;
@property (strong, nonatomic) SocializeUser *groupAdmin;
@property (nonatomic) double valuePrecision;
@property (nonatomic) double valueNotification;

@end

@implementation GroupSettingViewController



- (IBAction)done:(id)sender
{
    
    SocializeGroup* thisGroup = [[SocializeGroup alloc]initGroupWithName:self.groupTitle  precisionRadius:self.valuePrecision  warningRadius:self.valueNotification  andGroupAdmin:self.groupAdmin andMembers:self.groupUsers];
    
    SocializeGroupSpecific* thisGroupSpecific = [[SocializeGroupSpecific alloc]initGroupWithColor:self.colorPicker.groupColor isShownOnMap:self.addCurrentGroupToMainMap];
    
    
    //[[Singleton singleton].padronizedArrayOfColors removeObjectAtIndex:self.colorIndex];
    
    UINavigationController *navController = self.navigationController;
    [navController popToRootViewControllerAnimated:YES];
    
    
    //Below is code for Parse:
    PFObject *parseGroup = [PFObject objectWithClassName:@"Groups"];
    
    [parseGroup setObject:self.groupTitle forKey:@"groupName"];
    
    id groupPrecision = [NSNumber numberWithInteger: self.valuePrecision];
    [parseGroup setObject: groupPrecision forKey:@"groupPrecisionRadius"];
    
    id groupWarning = [NSNumber numberWithInteger: self.valueNotification];
    [parseGroup setObject: groupWarning forKey:@"groupWarningRadius"];
    
   // [parseGroup setObject:self.groupUsers forKey:@"usersInTheGroup"];
    
    [parseGroup saveInBackground];
  
}



- (void)viewWillAppear:(BOOL)animated
{
    UIColor *initialColor = [UIColor colorWithHue:0.0
                                       saturation:1.0
                                       brightness:1.0
                                            alpha:0.8];
    
    self.colorImage.image = [CustomUIImage changeIcon:[UIImage imageNamed:@"circle-grey-top.png"] toColor:initialColor];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImage *image;
//    image = [UIImage imageNamed:@"colorwheel1.png"];
//    [self.radialGradientColors setImage:image];
    
//    self.radialGradient.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"colorwheel1.png"]];
   
    
    
    
    
    self.addCurrentGroupToMainMap=true;
    
	// Do any additional setup after loading the view.
    
    self.warningRadiusLabel.text = [NSString stringWithFormat:@"0 Meters"];
    
    self.groupPrecisionRadiusLabel.text = [NSString stringWithFormat:@"Max."];
    
    self.warningRadiusSlider.continuous = YES; // Make the slider 'stick' as it is moved.
    [self.warningRadiusSlider setMinimumValue:0];
    [self.warningRadiusSlider setMaximumValue:12000];
    
    self.groupPrecisionRadiusSlider.continuous =YES;
    [self.groupPrecisionRadiusSlider setMinimumValue:0];
    [self.groupPrecisionRadiusSlider setMaximumValue:10000];
    
    //colorPicker code
    self.colorPicker.handleColor = [UIColor whiteColor];
    self.colorPicker.circleColor = [UIColor lightGrayColor];

}

- (IBAction)sliderValueChanged:(id)sender
{
    double index = (NSUInteger)(self.warningRadiusSlider.value + 0.5);
    // Round the number.
    [self.warningRadiusSlider setValue:index animated:NO];
    
    if(index <= 2000)
    {
        self.valueNotification = index/20;
        
        if(index >= 20.5 && index <= 40.5)
        {
            self.warningRadiusLabel.text = [NSString stringWithFormat:@"1 Meter"];
        }
        else
        {
            self.warningRadiusLabel.text = [NSString stringWithFormat:@"%.0lf Meters", self.valueNotification];
        }
    }
    
    else if(index < 5000)
    {
        self.valueNotification = 100 + 3*(index - 2000)/10;
        self.warningRadiusLabel.text = [NSString stringWithFormat:@"%.0lf Meters", self.valueNotification];
    }
    else if(index < 7000)
    {
        self.valueNotification = 1000 + (index - 5000)*2;
        self.warningRadiusLabel.text = [NSString stringWithFormat:@"%.2f Km", self.valueNotification/1000];
    }
    else
    {
        self.valueNotification = 5000 + (index - 7000)*19;
        self.warningRadiusLabel.text = [NSString stringWithFormat:@"%.2f Km", self.valueNotification/1000];
    }
}
    
    
- (IBAction)precisionSlidervalueChanged:(id)sender
{
    double index = (NSUInteger)(self.groupPrecisionRadiusSlider.value + 0.5);
    
    // Round the number.
    [self.groupPrecisionRadiusSlider setValue:index animated:NO];
    
    if(!index)
    {
        self.valuePrecision = 0;
        self.groupPrecisionRadiusLabel.text = @"Max.";
    }
    
    else if(index <= 2000)
    {
        self.valuePrecision = index/20;
        
        if(index >= 0 && index < 40.5)
        {
            self.groupPrecisionRadiusLabel.text = [NSString stringWithFormat:@"1 Meter"];
        }
        
        else
        {
            self.groupPrecisionRadiusLabel.text = [NSString stringWithFormat:@"%.0lf Meters", self.valuePrecision];
        }
    }
    else if(index < 5000)
    {
        self.valuePrecision = 100 + 3*(index - 2000)/10;
        self.groupPrecisionRadiusLabel.text = [NSString stringWithFormat:@"%.0lf Meters", self.valuePrecision];
    }
    else
    {
        self.valuePrecision = 1000 + (index - 5000)*1.8;
        self.groupPrecisionRadiusLabel.text = [NSString stringWithFormat:@"%.2f Km", self.valuePrecision/1000];
    }
}

- (IBAction)insertGroupInTheMainMapChanged:(id)sender
{
    if(self.selectIfGroupIsWillBeShownOnTheMapLabel.isOn)
    {
        self.addCurrentGroupToMainMap=true;
    }
    else
    {
        self.addCurrentGroupToMainMap=false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
