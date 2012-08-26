//
//  SMImageUtl.m
//  iBabe
//
//  Created by David on 26/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "SMImageUtl.h"

@implementation SMImageUtl

// --- Take screenshot for a particular UIView.
+ (UIImage *)screenshotFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}



// --- Take screenshot for a particular UIView and also limited to a particular area of that view.
+ (UIImage *)screenshotFromView:(UIView *)theView atTargetAreaFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	NSData* data =  UIImagePNGRepresentation ( result );
	UIImage* theImage = [UIImage imageWithData:data];

    return theImage;
}



+ (void)saveImageToIPhonePhotoAlbum:(UIImage *)image
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    [pool release];
}



@end