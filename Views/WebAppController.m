//
//  WebAppController.m
//  evalpal
//
//  Created by Bill MacAdam on 4/26/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import "WebAppController.h"
#import "ViewController.h"
#import "gpiNavigationController.h"
#import "gpiNetworkTest.h"

@implementation WebAppController

@synthesize webView, currentOrientation, loaded;

- (void)loadView
{
    loaded = FALSE;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    webView = [[UIWebView alloc] initWithFrame:screenFrame];
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
        
    NSURL *webAppUrl;
#if NIADA
    webAppUrl = [NSURL URLWithString:@"http://niada.gigglepop.com/app"];
#else
    webAppUrl = [NSURL URLWithString:@"http://evalpal.gigglepop.com/app"];
#endif
    
    NSURLRequest *request = [NSURLRequest requestWithURL:webAppUrl];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [webView loadRequest:request];
    [self setView:webView];

    currentOrientation = UIInterfaceOrientationPortrait;
}

#pragma mark - UIWebViewDelegates

- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    NSLog(@"web view loaded");
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"])
    {
        NSLog(@"web view fully loaded");
        UINavigationController *nav = (UINavigationController*)[self parentViewController];
        [nav popViewControllerAnimated:FALSE];
        loaded = TRUE;
    }
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *s = [[request URL] absoluteString];
    if ([s isEqualToString:@"evalpal://scan"] ||
         [s isEqualToString:@"niada://scan"]  )
     {
         gpiNavigationController *nav = (gpiNavigationController*)[self parentViewController];
         [nav setOrientationMask:UIInterfaceOrientationMaskLandscape];
         //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
         [[UIApplication sharedApplication] setStatusBarHidden:YES];
         ViewController *scanView = [[ViewController alloc] init];
         [self presentViewController:scanView animated:NO completion:NULL];
         //[nav pushViewController:scanView animated:FALSE];
         
         [scanView setParent:self];
         [scanView startScanner];
         
         // return to the home page before scanning
         [self OnHome];
         return NO;
     }
         
     return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error while loading WebView - %d", [error code]);
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error while loading WebView - %d", [error code]);
}

#pragma mark - Other Events
- (BOOL)OnHome
{
    [webView stringByEvaluatingJavaScriptFromString:@"OnHome();"];
    return YES;
}

-(BOOL)setVIN:(NSString *)vin
{
    [webView stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:@"TransferVIN(\"%@\");",
          vin]];
    
    return YES;
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
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	if([title isEqualToString:@"Try Again"]) {
		[self checkNetworkStatus];
	}
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"Web app controller orientation request");
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return currentOrientation;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currentOrientation = toInterfaceOrientation;
}

@end
