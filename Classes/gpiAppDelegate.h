//
//  gpiAppDelegate.h
//  evalpal
//
//  Created by Bill MacAdam on 4/26/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebAppController.h"

@interface gpiAppDelegate : UIResponder <UIApplicationDelegate>
{
    WebAppController *wac;
}

@property (strong, nonatomic) UIWindow *window;

@end
