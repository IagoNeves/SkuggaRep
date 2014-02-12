//
//  MainMapViewController.h
//  Socialize
//
//  Created by Lucas Mageste on 10/21/13.
//  Copyright (c) 2013 Lucas Mageste. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#include <math.h>
#import "MainMapViewAnnotation.h"
#import "SocializeUser.h"
#import "SocializeGroup.h"
//#import "Singleton.h"
#import "FacebookManagerStored.h"
#import "SCLoginViewController.h"
#import "AppDelegate.h"
#import "CustomUIImage.h"


@interface MainMapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//- (void)performLogin;

@property (nonatomic) bool isSpecificMap;
@property (nonatomic) bool goToGroupView;

@property (nonatomic) NSUInteger specificGroupArrayIndex;

//@property (weak, nonatomic) SocializeGroup* thisGroup;

@property (nonatomic) NSString *groupName;

@end

