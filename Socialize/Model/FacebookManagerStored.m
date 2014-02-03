//
//  FacebookManagerStored.m
//  MyFirstApp
//
//  Created by Helder Lima da Rocha on 10/28/13.
//  Copyright (c) 2013 BEPiD. All rights reserved.
//

#import "FacebookManagerStored.h"

@implementation FacebookManagerStored

static FacebookManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (FacebookManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

@end