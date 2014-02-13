//
//  FacebookManager.m
//  MyFirstApp
//
//  Created by Augusto Souza on 10/24/13.
//  Copyright (c) 2013 BEPiD. All rights reserved.
//

#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookManager()// <FBLoginViewDelegate>

@end

@implementation FacebookManager

- (BOOL)isLoggedIn
{
    return ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded);
}

- (void)login:(void(^)())completionHandler
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_birthday",@"friends_hometown",
                            @"friends_birthday",@"friends_location",
                            nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state, NSError *error) {
                                      if (completionHandler)
                                          completionHandler();
                                  }];
}

- (void)logout
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)fetchFriends:(void(^)())completionHandler
{
    FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=name,picture,birthday,location"];
    [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSArray *friendsUnordered = [result objectForKey:@"data"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        self.friends = [friendsUnordered sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        completionHandler();
    }];
}

- (void)fetchMyself:(void(^)())completionHandler
{
    FBRequest *myselfRequest = [FBRequest requestForGraphPath:@"me?fields=id,name"];
    [myselfRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        NSLog(@"Result: %@", result);
        NSDictionary *userInfo = (NSDictionary *)result;
        NSString *userName;
        NSString *userId;
        userName = [userInfo objectForKey:@"name"];
        userId = [userInfo objectForKey:@"id"];

        
        NSArray *friendsUnordered = [result objectForKey:@"data"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        self.friends = [friendsUnordered sortedArrayUsingDescriptors:@[sortDescriptor]];
        completionHandler();
    }];
}






//- (void) getFacebookName
//{
//    
//    [facebook requestWithGraphPath:@"me?fields=id,name" andDelegate:self];
//}
//
//#pragma mark - FBRequestDelegate methods
//
//- (void)request:(FBRequest *)request didLoad:(id)result {
//    
//    NSLog(@"Result: %@", result);
//    NSDictionary *userInfo = (NSDictionary *)result;
//    self.myName = [userInfo objectForKey:@"name"];
//    fb_id = [userInfo objectForKey:@"id"];
//}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSString *userName = user.name;
    
//    self.profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
}

@end
