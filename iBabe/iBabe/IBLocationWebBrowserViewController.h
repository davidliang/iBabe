//
//  IBLocationWebBrowserViewController.h
//  iBabe
//
//  Created by David on 14/09/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMStringUtil.h"
#import "MBProgressHUD.h"


@interface IBLocationWebBrowserViewController : UIViewController<UIWebViewDelegate, MBProgressHUDDelegate>
{
	MBProgressHUD* progressHUD;
	
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSString* locationName;

@end
