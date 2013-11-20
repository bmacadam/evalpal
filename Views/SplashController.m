//
//  gpiSplashController.m
//  evalpal
//
//  Created by Bill MacAdam on 4/29/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import "SplashController.h"
#import "gpiNetworkTest.h"

@interface SplashController ()

@end

@implementation SplashController

@synthesize webApp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // verify that there is a valid network connection
    [self checkNetworkStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

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
    
    [webApp loadView];
    
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
