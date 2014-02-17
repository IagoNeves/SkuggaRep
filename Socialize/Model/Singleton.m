//
//  Singleton.m
//  Socialize
//
//  Created by Lucas Mageste on 10/30/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

@synthesize allGroups;
@synthesize allGroupsSpecific;
@synthesize groupsToBeShowOnMap;
@synthesize userCoordinate;

+(Singleton *)singleton {
    static dispatch_once_t pred;
    static Singleton *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[Singleton alloc] init];
        shared.allGroups = [[NSMutableArray alloc]init];
        shared.allGroupsSpecific = [[NSMutableArray alloc]init];
        shared.groupsToBeShowOnMap = [[NSMutableArray alloc] init];
        shared.myID = [[NSString alloc]init];
        shared.myName = [[NSString alloc]init];
        shared.myPhoto = [[NSString alloc]init];
    });
    return shared;
}

@end
