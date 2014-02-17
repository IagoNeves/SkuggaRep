//
//  LoginUIViewController.m
//  Socialize
//
//  Created by Iago Neves on 2/13/14.
//  Copyright (c) 2014 Iago Neves. All rights reserved.
//

#import "LoginUIViewController.h"
#import "Singleton.h"
#import "FacebookManager.h"

@interface LoginUIViewController ()


@end

@implementation LoginUIViewController

//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    [self customInit];
//    return self;
//}

- (void) customInit
{
    if (self) {
        
        /*
         // Custom initialization
         
         // Create a FBLoginView to log the user in with basic, email and likes permissions
         // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
         
         
         FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
         
         
         
         // Set this loginUIViewController to be the loginView button's delegate
         loginView.delegate = self;
         
         loginView.frame = CGRectMake(9, 482, 170, 30);
         
         for (id obj in loginView.subviews)
         {
         if ([obj isKindOfClass:[UIButton class]])
         {
         UIButton * loginButton =  obj;
         //UIImage *loginImage = [UIImage imageNamed:@"face_1x.png"];
         //[loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
         [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
         [loginButton setTitle:@"Log in" forState:UIControlStateNormal];
         
         [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
         [loginButton setTitle:@"Log out" forState:UIControlStateHighlighted];
         
         [loginButton sizeToFit];
         }
         if ([obj isKindOfClass:[UILabel class]])
         {
         UILabel * loginLabel =  obj;
         loginLabel.text = @"Log in to facebook";
         loginLabel.frame = CGRectMake(50, 50, 271, 37);
         }
         }
         
         
         // Add the button to the view
         [self.view addSubview:loginView];
         */
        
        FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
        
        // Set this loginUIViewController to be the loginView button's delegate
        loginView.delegate = self;
        
        // Align the button in the center horizontally
        loginView.frame = CGRectMake(0, 0, 320, 45);
        //loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
        
        // Align the button in the center vertically
        //loginView.center = self.view;
        
        // Add the button to the view
        [self.view addSubview:loginView];
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self customInit];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInit];

    
    return;
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    
    [Singleton singleton].myName = user[@"name"];
    [Singleton singleton].myID = user[@"id"];
    [Singleton singleton].myPhoto = user[@"picture"][@"data"][@"url"];
    NSString *a = [[NSString alloc]init];
    a =[Singleton singleton].myPhoto;
  
    
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    self.statusLabel.text = @"You're logged in as";
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    self.profilePictureView.profileID = nil;
//    self.nameLabel.text = @"";
//    self.statusLabel.text= @"You're not logged in!";
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end


