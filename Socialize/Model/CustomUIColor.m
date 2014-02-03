//
//  CustomUIColor.m
//  Socialize
//
//  Created by Lucas Mageste on 11/13/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "CustomUIColor.h"

@implementation CustomUIColor

+ (UIColor *)darkerColorForColor:(UIColor *)c{
    CGFloat hue, sat, brt, alp;
    if ([c getHue:&hue saturation:&sat brightness:&brt alpha:&alp])
        return [UIColor colorWithHue:hue saturation:MAX(sat-0.6, 0) brightness:brt alpha:alp];
    return nil;
}

@end
