//
//  SMImageUtl.h
//  iBabe
//
//  Created by David on 26/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface SMImageUtl : NSObject
{
}

+ (UIImage *)screenshotFromView:(UIView *)theView;
+ (UIImage *)screenshotFromView:(UIView *)theView atTargetAreaFrame:(CGRect)r;
+ (void)saveImageToIPhonePhotoAlbum:(UIImage *)image;

@end