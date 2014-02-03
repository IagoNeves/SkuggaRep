//
//  Singleton.h
//  Socialize
//
//  Created by Lucas Mageste on 10/30/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Singleton : NSObject

@property (nonatomic, retain) NSMutableArray *allGroups;

@property (nonatomic, retain) NSMutableArray *allGroupsSpecific;

@property (nonatomic, retain) NSMutableArray *groupsToBeShowOnMap;

@property (nonatomic) CLLocationCoordinate2D userCoordinate;

@property (nonatomic) NSUInteger colorIndex;

+(Singleton *)singleton;

@end
