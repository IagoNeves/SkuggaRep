//
//  SocializeGroup.m
//  Socialize
//
//  Created by Lucas Mageste on 10/30/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "SocializeGroup.h"
#import "SocializeUser.h"
#import "Singleton.h"

@implementation SocializeGroup

- (id) initGroupWithName: (NSString*) theName precisionRadius: (NSUInteger) theRadius warningRadius: (NSUInteger) theWarningRadius andGroupAdmin: (SocializeUser *) groupAdmin andMembers: (NSMutableArray *) groupMembersArray
{
    self=[super init];
    if(self)
    {
        self.groupName = [theName copy];
        self.groupPrecisionRadius = theRadius;
        self.groupWarningRadius = theWarningRadius;
        self.usersInTheGroup = [NSMutableArray array];
        self.groupAdmin = groupAdmin;
        
        for(SocializeUser* eachUser in groupMembersArray)
        {
            [self addUserToTheGroup:eachUser];
            [eachUser.groupsInWhichParticipates  addObject:self];
            
            NSArray * sortedArray = [eachUser.groupsInWhichParticipates sortedArrayUsingFunction:customSort context:NULL];
            
            [eachUser.groupsInWhichParticipates removeAllObjects];
            eachUser.groupsInWhichParticipates = [sortedArray mutableCopy];
        }
        
         [[Singleton singleton].allGroups addObject:self];
         [[Singleton singleton].groupsToBeShowOnMap addObject:self];
    }
    return self;
}

NSInteger customSort(id obj1, id obj2, void *context)
{
    SocializeGroup *group1 = (SocializeGroup *) obj1;
    SocializeGroup *group2 = (SocializeGroup *) obj2;
    
    return group1.groupPrecisionRadius > group2.groupPrecisionRadius;
}

- (void) addUserToTheGroup: (SocializeUser*) groupMember
{
    bool alreadyInTheGroup=false;
    
    for(SocializeUser* everyUser in self.usersInTheGroup)
    {
        if([everyUser.identificator isEqualToString:groupMember.identificator])
        {
            alreadyInTheGroup=true;
            break;
        }
    }
    
    if(!alreadyInTheGroup)
        [self.usersInTheGroup addObject:groupMember];
}

- (void) removeUserInTheGroup: (NSMutableString*) userID
{
    for(SocializeUser* everyUser in self.usersInTheGroup)
    {
        if([everyUser.identificator isEqualToString:userID])
        {
            [self.usersInTheGroup removeObject:everyUser];
        }
    }
}

- (void) updateGroupInformationWithName: (NSString*) theName warningRadius: (NSUInteger) theWarningRadius precisionRadius: (NSUInteger) thePrecisionRadius
{
    self.groupName = [theName copy];
    self.groupPrecisionRadius = thePrecisionRadius;
    self.groupWarningRadius = theWarningRadius;
}

//- (void) changeAnnotationColor: (UIColor*) theColor
//{
//    self.groupAnnotationColor = [theColor copy];
//}

@end
