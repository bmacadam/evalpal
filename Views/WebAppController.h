//
//  WebAppController.h
//  evalpal
//
//  Created by Bill MacAdam on 4/26/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

@interface WebAppController : UIViewController <UIWebViewDelegate, NSURLConnectionDataDelegate>

@property (nonatomic) BOOL loaded;

@property (atomic, readonly) UIWebView *webView;

@property (nonatomic) UIInterfaceOrientation currentOrientation;

- (BOOL) OnHome;
- (BOOL) setVIN: (NSString *) vin;
- (BOOL) checkNetworkStatus;

@end
