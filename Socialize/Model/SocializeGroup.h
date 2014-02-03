//
//  SocializeGroup.h
//  Socialize
//
//  Created by Lucas Mageste on 10/30/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SocializeUser;

@interface SocializeGroup : NSObject

@property (nonatomic, strong) NSMutableArray* usersInTheGroup;

@property (nonatomic, strong) NSString* groupName;

@property (nonatomic, strong) UIImage* groupImage;

@property (nonatomic, strong) SocializeUser* groupAdmin;

@property (nonatomic) NSUInteger groupPrecisionRadius;

@property (nonatomic) NSUInteger groupWarningRadius;

//@property (nonatomic) bool enableThisGroup;


- (id) initGroupWithName: (NSString*) theName precisionRadius: (NSUInteger) theRadius warningRadius: (NSUInteger) theWarningRadius andGroupAdmin: (SocializeUser *) groupAdmin andMembers: (NSMutableArray *) groupMembersArray;

- (void) updateGroupInformationWithName: (NSString*) theName warningRadius: (NSUInteger) theWarningRadius precisionRadius: (NSUInteger) thePrecisionRadius;

- (void) removeUserInTheGroup: (NSMutableString*) userID;

- (void) addUserToTheGroup: (SocializeUser*) groupMember;

//- (void) changeAnnotationColor: (UIColor*) theColor;

@end
