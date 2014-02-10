//
//  SocializeUser.m
//  Socialize
//
//  Created by Lucas Mageste on 10/28/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "SocializeUser.h"

@implementation SocializeUser

- (SocializeUser *) initWithName: (NSMutableString*) theName photo: (NSMutableString*) thePhoto andIdentifier: (NSMutableString*) theIdentificator
{
    if(self==nil)
        self = [super init];
    if(self)
    {
        self.name = [theName copy];
        self.photo = [thePhoto copy];
        self.identificator=[theIdentificator copy];
        self.groupsInWhichParticipates = [NSMutableArray array];
        self.lastUpdateDate = [[NSDate alloc] init];
        self.isAnUpdateToCoordinateAvailable = true;
        
        //self.identificator = self.name; //depois muda conforme necessário
    }
    
    return self;
}

- (void) updateCoordinate: (CLLocationCoordinate2D) theCoordinate andCoordinateDate: (NSDate*) theDate
{
    self.coordinate = theCoordinate;
    [self scrambleCoordinate];
    self.lastUpdateDate = [theDate copy];
}

- (void) scrambleCoordinate
{
    SocializeGroup* firstGroup = [self.groupsInWhichParticipates firstObject];
    
    double totalErrorTolerated = firstGroup.groupPrecisionRadius;
    
    CLLocationDistance propositalErrorInLatitudeInMeters = arc4random()%(firstGroup.groupPrecisionRadius+1);
    totalErrorTolerated-=propositalErrorInLatitudeInMeters;
    CLLocationDistance propositalErrorInLongitudeInMeters = arc4random()%(firstGroup.groupPrecisionRadius+1);
    
    CLLocationDistance lat = (( self.coordinate.latitude / 180.0f) * M_PI);
    
    // Set up "Constants"
    
    double m1 = 111132.92;		// latitude calculation term 1
    
    double m2 = -559.82;		// latitude calculation term 2
    
    double m3 = 1.175;			// latitude calculation term 3
    
    double m4 = -0.0023;		// latitude calculation term 4
    
    double p1 = 111412.84;		// longitude calculation term 1
    
    double p2 = -93.5;			// longitude calculation term 2
    
    double p3 = 0.118;			// longitude calculation term 3
    
    // Calculate the length of a degree of latitude and longitude in meters
    
    CLLocationDistance propositalErrorInLatitudeInDegrees = propositalErrorInLatitudeInMeters/(m1 + (m2 * cos(2 * lat)) + (m3 * cos(4 * lat)) + (m4 * cos(6 * lat)));
    
    CLLocationDistance propositalErrorInLongitudeInDegrees = propositalErrorInLongitudeInMeters/((p1 * cos(lat)) + (p2 * cos(3 * lat)) + (p3 * cos(5 * lat)));
    
    int isItNegativeForLatitude=0;
    int isItNegativeForLongitude=0;
    
    while(isItNegativeForLatitude==0)
    {
        isItNegativeForLatitude = arc4random()%3-1;
    }
    
    while(isItNegativeForLongitude==0)
    {
        isItNegativeForLongitude = arc4random()%3-1;
    }
    
    self.coordinate = CLLocationCoordinate2DMake(self.coordinate.latitude + propositalErrorInLatitudeInDegrees*isItNegativeForLatitude, self.coordinate.longitude +propositalErrorInLongitudeInDegrees*isItNegativeForLongitude);
    
}

@end
