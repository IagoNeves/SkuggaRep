//
//  CustomUIImage.m
//  Socialize
//
//  Created by Lucas Mageste on 11/13/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "CustomUIImage.h"

@implementation CustomUIImage

+ (UIImage*) changeIcon: (UIImage*) image toColor: (UIColor*) color
{
    //image = [self image:image ByApplyingAlpha:1];
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // draw tint color
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [color setFill];
    CGContextFillRect(context, rect);
    
    // replace luminosity of background (ignoring alpha)
    CGContextSetBlendMode(context, kCGBlendModeLuminosity);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, rect, image.CGImage);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  image;
}

@end
