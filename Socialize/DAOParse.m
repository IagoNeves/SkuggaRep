//
//  DAOParse.m
//  Socialize
//
//  Created by Iago Neves on 2/6/14.
//  Copyright (c) 2014 Iago Neves. All rights reserved.
//

#import "DAOParse.h"
#import <Parse/Parse.h>
#import "SocializeGroup.h"
#import "SocializeUser.h"

@implementation DAOParse

- (void)fetchAllValuesOfClass: (NSString *)class andColumns: (NSMutableArray *)arrayWithColumns
{
    NSMutableArray *ResultsArray = [[NSMutableArray alloc]init];
    //make protection code in case the column is null for a certain value in the relational table
    PFQuery *groupsQuery = [PFQuery queryWithClassName:[NSString stringWithFormat:@"%@",class]];
    //[groupsQuery selectKeys:@[@"groupName", @"groupColor"]];
    [groupsQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
     {
         int i=0;
         NSLog(@"%@",error);
         for (NSString *columnKey in arrayWithColumns)
         {
             ResultsArray[i] = [[NSMutableArray alloc]init];
             for (PFObject *object in results)
             {
                 //specific case for the color Column (which is a file)
                 if ([columnKey isEqualToString:@"groupColor"])
                 {
                     if ([object objectForKey:@"groupColor"])
                     {
                         //this color thing is cauing the long running parse operation
                         PFFile *colorFile = [object objectForKey:@"groupColor"];
                         NSData *colorData = [colorFile getData];
                         UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
                         [ResultsArray[i] addObject:color];
                     }
                     else
                     {
                         [ResultsArray[i] addObject:[UIColor whiteColor]];
                     }
                 }
                 //if anything other than the color Column
                 else if ([object objectForKey:[NSString stringWithFormat:@"%@",columnKey]])
                 {
                     [ResultsArray[i] addObject:[object objectForKey:[NSString stringWithFormat:@"%@",columnKey]]];
                 }
                 else
                     //make protection code in case the table has undefined values
                 {
                 }
            }
            i++;
         }
         [self.delegate hasCompletedGroupColumnsDataFetch:ResultsArray];
     }];
}


- (void)fetchAllUsersInGroup: (NSString *)groupName
{
    NSMutableArray *ResultsArray = [[NSMutableArray alloc]init];
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Groups"];
    [groupQuery whereKey:@"groupName" equalTo:groupName];
    __block int counter = 0;
    
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
     {
         NSMutableArray *usersInTheGroup = [[NSMutableArray alloc]init];
         NSMutableArray *objectIDsArray = [[NSMutableArray alloc]init];
         
         usersInTheGroup = [results[0] objectForKey:@"usersInTheGroup"];
         int i=0;
         for (PFObject *user in usersInTheGroup)
         {
             ResultsArray[i] = [[NSMutableArray alloc]init];
             objectIDsArray[i] = user.objectId;
             
             PFQuery *userQuery = [PFQuery queryWithClassName:@"User"];
             [userQuery getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@",objectIDsArray[i]] block:^(PFObject *user, NSError *error)
              {
                  SocializeUser *socializeUser = [[SocializeUser alloc]init];
                  socializeUser = [socializeUser initWithName:[user objectForKey:@"name"] photo:[user objectForKey:@"photo"] andIdentifier:[user objectForKey:@"identificator"]];
                  
                  ResultsArray[i] = socializeUser;

                  counter ++;
                  if (counter == [usersInTheGroup count])
                  {
                      [self.delegate hasCompletedGroupUsersDataFetch:ResultsArray];
                  }
              }];
             i++;
         }
     }];
}

- (void)fetchGroupWithName: (NSString *)groupName
{
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Groups"];
    [groupQuery whereKey:@"groupName" equalTo:groupName];
    
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
     {
         NSMutableArray *usersInTheGroup = [[NSMutableArray alloc]init];
         NSMutableArray *objectIDsArray = [[NSMutableArray alloc]init];
         usersInTheGroup = [results[0] objectForKey:@"usersInTheGroup"];
         int i=0;
         for (PFObject *user in usersInTheGroup)
         {
             
             objectIDsArray[i] = user.objectId;
             
             PFQuery *userQuery = [PFQuery queryWithClassName:@"User"];
             [userQuery getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@",objectIDsArray[i]] block:^(PFObject *user, NSError *error)
              {
                  SocializeUser *socializeUser = [[SocializeUser alloc]init];
                  socializeUser = [socializeUser initWithName:[user objectForKey:@"name"] photo:[user objectForKey:@"photo"] andIdentifier:[user objectForKey:@"identificator"]];
                  
                  usersInTheGroup[i] = socializeUser;
              }];
             i++;
         }
         
         PFObject *ResultsGroup = results[0];
         NSString *groupObjectID = [[NSString alloc]init];
         groupObjectID = ResultsGroup.objectId;
         
         PFQuery *groupInfoQuery = [PFQuery queryWithClassName:@"Groups"];
         if (usersInTheGroup[0])
         {
             [groupInfoQuery getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@",groupObjectID ]block:^(PFObject *group, NSError *error)
              {
                  SocializeGroup *socializeGroup = [[SocializeGroup alloc]init];
                  //groupAdmin is getting a random member (to change)
                  socializeGroup = [socializeGroup initGroupWithName:[group objectForKey:@"groupName"] precisionRadius:[[group objectForKey:@"groupPrecisionRadius"] intValue] warningRadius:[[group objectForKey:@"groupWarningRadius"] intValue]  andGroupAdmin:usersInTheGroup[0] andMembers:usersInTheGroup];
                  [self.delegate hasCompletedGroupDataFetch:socializeGroup];
              }];
         }
    }];
}


- (void)saveGroup: (NSString *)groupName withUsers: (NSMutableArray *)groupUsers warningRadius:(NSUInteger)groupWarningRadius precisionRadius: (NSUInteger)groupPrecisionRadius andColor: (UIColor *) groupColor
{
    PFObject *parseGroup = [PFObject objectWithClassName:@"Groups"];
    
    [parseGroup setObject:groupName forKey:@"groupName"];
    
    id groupPrecision = [NSNumber numberWithInteger: groupPrecisionRadius];
    [parseGroup setObject: groupPrecision forKey:@"groupPrecisionRadius"];
    
    id groupWarning = [NSNumber numberWithInteger: groupWarningRadius];
    [parseGroup setObject: groupWarning forKey:@"groupWarningRadius"];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:groupColor];
    PFFile *colorFile = [PFFile fileWithData:colorData];
    [parseGroup setObject:colorFile forKey:@"groupColor"];
    
    for (SocializeUser *groupUser in  groupUsers)
    {
        NSString *userIdentificator= groupUser.identificator;
        
        //insert query
        PFQuery *userQuery = [PFQuery queryWithClassName:@"User"];
        [userQuery whereKey:@"identificator" equalTo:userIdentificator];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
         {
            if (!results)
            {
                PFObject *user = [PFObject objectWithClassName:@"User"];
                [user setObject:groupUser.name forKey:@"name"];
                [user setObject:groupUser.photo forKey:@"photo"];
                [user setObject:groupUser.identificator forKey:@"identificator"];
                [user setObject:groupUser.lastUpdateDate forKey:@"lastUpdateDate"];
                [user saveInBackground];
                [parseGroup addObject:user forKey:@"usersInTheGroup"];
            }
            else
             {
                 [parseGroup addObject:results[0] forKey:@"usersInTheGroup"];
             }
        }];
    }
    [parseGroup saveInBackground];
}



- (void)updateUsersOfGroup: (NSString *)groupName andColumns: (NSMutableArray *)arrayWithColumns andUpdates: (NSMutableArray *)updatesArray
{
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Groups"];
    [groupQuery whereKey:@"groupName" equalTo:groupName];
    
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
     {
         NSMutableArray *usersInTheGroup = [[NSMutableArray alloc]init];
         NSMutableArray *objectIDsArray = [[NSMutableArray alloc]init];
         
         usersInTheGroup = [results[0] objectForKey:@"usersInTheGroup"];
         int i=0;
         for (PFObject *user in usersInTheGroup)
         {
             objectIDsArray[i] = user.objectId;
             
             PFQuery *userQuery = [PFQuery queryWithClassName:@"User"];
             [userQuery getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@",objectIDsArray[i]] block:^(PFObject *user, NSError *error)
              {
                  SocializeUser *socializeUser = [[SocializeUser alloc]init];
                  socializeUser = [socializeUser initWithName:[user objectForKey:@"name"] photo:[user objectForKey:@"photo"] andIdentifier:[user objectForKey:@"identificator"]];
                  
                  for (int j=0; j < [arrayWithColumns count]; j++)
                  {
                      user[[NSString stringWithFormat:@"%@",arrayWithColumns[j]]] = updatesArray[j];
                  }
                  [user saveInBackground];
              }];
             i++;
         }
     }];
}

- (void)updateMyLocation: (CLLocationCoordinate2D)coordinate andId: (NSString *)myID
{
     PFQuery *userQuery = [PFQuery queryWithClassName:@"User"];
     [userQuery getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@",myID] block:^(PFObject *user, NSError *error)
      {
          PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
          user[@"coordinate"] = geoPoint;
          user[@"isRefreshPending"] = [NSNumber numberWithBool:NO];
          [user saveInBackground];
      }];

}


@end




