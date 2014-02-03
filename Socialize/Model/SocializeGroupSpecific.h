//
//  SocializeGroupSpecific.h
//  Socialize
//
//  Created by Iago Neves on 1/16/14.
//  Copyright (c) 2014 Iago Neves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocializeGroupSpecific : NSObject

@property (nonatomic, strong) UIColor* groupColor;

@property (nonatomic) bool isShownOnMap;

- (id) initGroupWithColor: (UIColor*) theColor isShownOnMap: (bool) yesOrNo;

- (void) updateGroupInformationWithColor: (UIColor*) color andIsShownOnMap: (bool) yesOrNo;
@end

