//
//  FacebookManager.h
//  MyFirstApp
//
//  Created by Augusto Souza on 10/24/13.
//  Copyright (c) 2013 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookManager : NSObject

@property (nonatomic, strong) NSArray *friends;

@property (nonatomic, strong) NSString *myName;

@property(nonatomic) BOOL isLogedIn;

- (BOOL)isLoggedIn;
- (void)login:(void(^)())completionHandler;
- (void)logout;
- (void)fetchFriends:(void(^)())completionHandler;

@end
