//
//  SocializeGroupSpecific.m
//  Socialize
//
//  Created by Iago Neves on 1/16/14.
//  Copyright (c) 2014 Iago Neves. All rights reserved.
//

#import "SocializeGroupSpecific.h"
#import "Singleton.h"

@implementation SocializeGroupSpecific

- (id) initGroupWithColor: (UIColor*) color isShownOnMap: (bool) yesOrNo
{
    self=[super init];
    if(self)
    {
        self.groupColor = color;
        self.isShownOnMap = yesOrNo;
        [[Singleton singleton].allGroupsSpecific addObject:self];
    }
    return self;
}

- (void) updateGroupInformationWithColor: (UIColor*) color andIsShownOnMap: (bool) yesOrNo
{
    self.groupColor = [color copy];
    self.isShownOnMap = yesOrNo;
}

@end
