//
//  gpiNavigationController.m
//  evalpal
//
//  Created by Bill MacAdam on 4/30/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import "gpiNavigationController.h"

@interface gpiNavigationController ()

@end

@implementation gpiNavigationController

@synthesize orientationMask;

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
	// Do any additional setup after loading the view.
}

-(NSUInteger)supportedInterfaceOrientations
{
    if ([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
    {
        //NSLog(@"Nav controller  rotation %d", orientationMask);
        //return orientationMask; // [self.topViewController supportedInterfaceOrientations];
        //NSLog(@"Nav controller  rotation %d", [self.topViewController supportedInterfaceOrientations]);
        return [self.topViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    if ([self.topViewController respondsToSelector:@selector(shouldAutorotate)])
    {
        //NSLog(@"Autorotate is %@", [self.topViewController shouldAutorotate] ? @"true" : @"false");
        return [self.topViewController shouldAutorotate];
    }
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([self.topViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)])
    {
        //NSLog(@"Preferred orientation is %d", [self.topViewController preferredInterfaceOrientationForPresentation]);
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
