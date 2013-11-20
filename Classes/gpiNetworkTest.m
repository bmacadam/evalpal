//
//  gpiNetworkTest.m
//  evalpal
//
//  Created by Bill MacAdam on 5/16/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import "gpiNetworkTest.h"
#import "Reachability.h"

@implementation gpiNetworkTest

- (BOOL)checkNetworkStatus
{
    NetworkStatus currentStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (currentStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                        message:@"You currently have no connection to the Internet.  Without a connection this application will not function properly.  Please enable your cellular service or Wi-Fi and tap Try Again"
                                                       delegate:self
                                              cancelButtonTitle:@"Try Again"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	if([title isEqualToString:@"Try Again"]) {
		[self checkNetworkStatus];
	}
}
@end
