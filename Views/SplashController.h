//
//  gpiSplashController.h
//  evalpal
//
//  Created by Bill MacAdam on 4/29/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WebAppController.h"

@interface SplashController : UIViewController <UIAlertViewDelegate>

@property (atomic) WebAppController *webApp;

@end