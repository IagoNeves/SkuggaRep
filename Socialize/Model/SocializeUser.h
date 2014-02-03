//
//  SocializeUser.h
//  Socialize
//
//  Created by Lucas Mageste on 10/28/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SocializeGroup.h"
#import "SocializeGroupSpecific.h"

@interface SocializeUser : NSObject

@property (nonatomic, strong) NSMutableString* name;

@property (nonatomic, strong) NSMutableString* photo;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSMutableArray* groupsInWhichParticipates; //cada elemento é da classe grupo

@property (nonatomic, strong) NSMutableString* identificator;

@property (nonatomic) NSDate* lastUpdateDate;

@property (nonatomic) NSUInteger leastPrecisionRadius;

@property (nonatomic) SocializeGroup* mostPreciseDrawableGroup;

@property (nonatomic) SocializeGroupSpecific* mostPreciseDrawableGroupSpecific;

@property (nonatomic) bool isAnUpdateToCoordinateAvailable;

- (id) initWithName: (NSMutableString*) theName photo: (NSMutableString*) thePhoto andIdentifier: (NSMutableString*) theIdentificator;

- (void) updateCoordinate: (CLLocationCoordinate2D) theCoordinate andCoordinateDate: (NSDate*) theDate;

@end
