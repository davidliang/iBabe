//
//  IBAboutViewController.h
//  iBabe
//
//  Created by David on 24/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD/MBProgressHUD.h"

@interface IBAboutViewController : UIViewController<UIWebViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *progress;
}
@property (retain, nonatomic) IBOutlet UIWebView *webAbout;

@end