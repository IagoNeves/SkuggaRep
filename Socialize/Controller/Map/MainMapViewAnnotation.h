//
//  MainMapViewAnnotation.h
//  Socialize
//
//  Created by Lucas Mageste on 10/22/13.
//  Copyright (c) 2013 Lucas Mageste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeUser.h"
#import <MapKit/MapKit.h>

@interface MainMapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *name;
//@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSDate* lastUpdateDate;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString* whichGroup;
@property (nonatomic) NSUInteger radiusOfPrecision;
@property (nonatomic) bool inRange;

@property (nonatomic, strong) SocializeUser* correspondingUser;

- (id)initWithName:(NSString*)theName /*address:(NSString*)address*/ coordinate:(CLLocationCoordinate2D)theCoordinate group: (NSString*) theGroup radius: (NSUInteger) theRadius andDate: (NSDate*) theDate;
- (id) initWithCorrespondingUser: (SocializeUser*) theUser;



//- (MKMapItem*)mapItem;

@end