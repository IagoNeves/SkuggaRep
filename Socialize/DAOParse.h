//
//  DAOParse.h
//  Socialize
//
//  Created by Iago Neves on 2/6/14.
//  Copyright (c) 2014 Iago Neves. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAOParseDelegate

@optional
- (void)hasCompletedGroupDataFetch:(NSMutableArray *)resultsArray;
- (void)hasCompletedUserDataFetch:(NSMutableArray *)resultsArray;

@end


@interface DAOParse : NSObject

- (void)fetchAllValuesOfClass: (NSString *)Class andColumns: (NSMutableArray *)arrayWithColumns;

- (void)fetchAllUsersInGroup: (NSString *)groupName andColumns: (NSMutableArray *)arrayWithColumns;

@property (nonatomic, assign) id<DAOParseDelegate> delegate;

@end
