//
//  MainMapViewAnnotation.m
//  Socialize
//
//  Created by Lucas Mageste on 10/22/13.
//  Copyright (c) 2013 Lucas Mageste. All rights reserved.
//

#import "MainMapViewAnnotation.h"
#import <AddressBook/AddressBook.h>

@interface MainMapViewAnnotation ()

@end

@implementation MainMapViewAnnotation

- (id)initWithName:(NSString*)theName /*address:(NSString*)address*/ coordinate:(CLLocationCoordinate2D)theCoordinate group: (NSString*) theGroup radius: (NSUInteger) theRadius andDate: (NSDate*) theDate
{
    if ((self = [super init])) {
        self.name = [theName copy];
        //self.address = address;
        self.lastUpdateDate = theDate;
        self.coordinate = theCoordinate;
        self.whichGroup = theGroup;
        self.radiusOfPrecision = theRadius;
        self.inRange = false;
    }
    return self;
}

- (id) initWithCorrespondingUser: (SocializeUser*) theUser
{
    if ((self = [super init])) {
        self.correspondingUser = theUser;
    }
    return self;
}

- (NSString *)title {
    return self.correspondingUser.name;
}

- (NSString *)subtitle {
    NSTimeInterval timeInterval = [self.correspondingUser.lastUpdateDate timeIntervalSinceNow];
    
    NSString* timeElapsed;
    
    if(timeInterval > 86400)
    {
        if(timeInterval/2<86400)
            timeElapsed = [NSString stringWithFormat:@"location last updated 1 day ago"];
        else
            timeElapsed = [NSString stringWithFormat:@"location last updated %d days ago", (int) timeInterval/86400];
    }
    else if(timeInterval > 3600)
    {
        if(timeInterval/2<3600)
            timeElapsed = [NSString stringWithFormat:@"location last updated 1 hour ago"];
        else
            timeElapsed = [NSString stringWithFormat:@"location last updated %d hours ago", (int) timeInterval/3600];
    }
    else if(timeInterval > 60)
    {
        if(timeInterval/2<60)
            timeElapsed = [NSString stringWithFormat:@"location last updated 1 minute ago"];
        else
            timeElapsed = [NSString stringWithFormat:@"location last updated %d minutes ago", (int) timeInterval/60];
    }
    else
    {
        if(timeInterval/2<1)
            timeElapsed = [NSString stringWithFormat:@"location last updated 1 second ago"];
        else
            timeElapsed = [NSString stringWithFormat:@"location last updated %d seconds ago", (int) timeInterval];
    }
    
    return timeElapsed;
}

- (CLLocationCoordinate2D)coordinate {
    return self.correspondingUser.coordinate;
}

/*
 - (MKMapItem*)mapItem {
 NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
 
 MKPlacemark *placemark = [[MKPlacemark alloc]
 initWithCoordinate:self.coordinate
 addressDictionary:addressDict];
 
 MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
 mapItem.name = self.title;
 
 return mapItem;
 }
 */

@end