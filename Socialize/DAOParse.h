//
//  DAOParse.h
//  Socialize
//
//  Created by Iago Neves on 2/6/14.
//  Copyright (c) 2014 Iago Neves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SocializeGroup.h"

@protocol DAOParseDelegate

@optional
- (void)hasCompletedGroupColumnsDataFetch:(NSMutableArray *)resultsArray;
- (void)hasCompletedGroupUsersDataFetch:(NSMutableArray *)resultsArray;
- (void)hasCompletedGroupDataFetch:(SocializeGroup *)group;


@end


@interface DAOParse : NSObject

- (void)fetchAllValuesOfClass: (NSString *)Class andColumns: (NSMutableArray *)arrayWithColumns;

- (void)fetchAllUsersInGroup: (NSString *)groupName;

- (void)fetchGroupWithName: (NSString *)groupName;

- (void)saveGroup: (NSString *)groupName withUsers: (NSMutableArray *)groupUsers warningRadius:(NSUInteger)groupWarningRadius precisionRadius: (NSUInteger)groupPrecisionRadius andColor: (UIColor *) groupColor;

@property (nonatomic, assign) id<DAOParseDelegate> delegate;

@end
