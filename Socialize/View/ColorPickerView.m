//
//  ColorPickerView.m
//  Socialize
//
//  Created by Iago Almeida Neves on 11/30/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import "ColorPickerView.h"
#import "Singleton.h"
#import "CustomUIImage.h"

@interface ColorPickerView()

@property (nonatomic) NSInteger circleRadius;
@property (nonatomic) NSInteger handleSize;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *radialGradient;

@end


@implementation ColorPickerView


-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.circleRadius = self.frame.size.width/3;
        self.handleSize = self.frame.size.width/4;
        self.groupColor = [UIColor colorWithHue:0.0
                                     saturation:1.0
                                     brightness:1.0
                                          alpha:0.8];
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    
     [super drawRect:rect];
    UIImage *image;
    
    image = [UIImage imageNamed:@"colorwheel1.png"];
    
    [image drawInRect:self.bounds];
    
    //Below is code for an empty arc
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //This draws a circunference (an arc, actually, as it has width)
    //CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, self.circleRadius, 0, M_PI *2, 0);
    
    //Set the stroke color
    //[[UIColor blackColor]setStroke];
    [self.circleColor setStroke];
    
    //Set the line width
    CGContextSetLineWidth(context, self.handleSize);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    
    //save the context content into the image mask
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    /** Clip Context to the mask **/
    CGContextSaveGState(context);
    
    CGContextClipToMask(context, self.bounds, mask);
    CGImageRelease(mask);
    
    
    
    CGContextRestoreGState(context);
    
    [self drawTheHandle:context];

    
    
    

    
}


-(CGPoint)pointFromAngle:(int)angleInt
{
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - self.handleSize/2, self.frame.size.height/2 - self.handleSize/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + self.circleRadius * sin(-[self angleInRadians:angleInt])) ;
    result.x = round(centerPoint.x + self.circleRadius * cos(-[self angleInRadians:angleInt]));
    
    return result;
}

-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);
    
    //Get the handle position
    CGPoint handleCenter =  [self pointFromAngle: self.angle];
    
    //A way to color it
    //[[UIColor colorWithWhite:1.0 alpha:0.7]set];
    [self.handleColor set];
    
    //draw it
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, self.handleSize, self.handleSize));
    
    CGContextRestoreGState(ctx);
}

- (float) angleInRadians: (float)angleInDegrees
{
    float angleInRadians = (M_PI * (angleInDegrees)) / 180;
    return angleInRadians;
}

- (float) angleInDegrees:(float)angleInRadians
{
    float angleInDegrees = (180.0 * (angleInRadians)) / M_PI;
    return angleInDegrees;
}


#pragma mark - User Interaction Methods

-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = [self AngleFromNorth:centerPoint lastPoint:lastPoint isItFlipped:NO];
    
    //Store the new angle
    self.angle = 360 - (int)currentAngle;
    
    float currentHue = (self.angle/360.0);
    UIColor *currentColor = [UIColor colorWithHue:currentHue
                                       saturation:1.0
                                       brightness:1.0
                                            alpha:0.8];
    self.imageView.image = [CustomUIImage changeIcon:[UIImage imageNamed:@"circle-grey-top.png"] toColor:currentColor];
    
    self.groupColor = currentColor;
    
    //Redraw
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get touch location
    UITouch *currentTouch = [touches anyObject];
    CGPoint currentLocation = [currentTouch locationInView:self];
    
    //Use the location to design the Handle
    [self movehandle:currentLocation];
}

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.
//Converted form c to  Objective-C by Iago
- (int)AngleFromNorth:(CGPoint)p1 lastPoint:(CGPoint)p2 isItFlipped:(BOOL) flipped
{
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt((v.x)*(v.x) + (v.y)*(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = [self angleInDegrees:radians];
    [self angleInDegrees:radians];
    return (result >=0  ? result : result + 360.0);
}

@end
