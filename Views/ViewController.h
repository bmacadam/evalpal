//
//  ViewController.h
//  inigmaSDKDemo
//
//  Created by 1 1 on 4/1/12.
//  Copyright (c) 2012 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#ifdef SIMULATOR
#include "SimulatedScanner.h"
#else
#include "Scanner.h"
#endif

#include "KeyboardViewController.h"

@class WebAppController;

@interface ViewController : UIViewController{
	IBOutlet UIButton *HomeButton;
	IBOutlet UIButton *TorchButton;
    IBOutlet UIButton *KeyboardButton;
    IBOutlet UIView *topBar;
    IBOutlet UIView *bottomBar;
    IBOutlet UILabel *versionLabel;
    IBOutlet UILabel *appLabel;
	CScanner* m_pScanner;
    int m_bTorch;
	CALayer *laser_layer;
	CABasicAnimation *laser_animation;
    KeyboardViewController *keyboardView;
}

@property WebAppController *parent;

-(void) initLocal;
-(void) onError: (const char*) str;
-(void) onNotify: (const char*) str;
-(void) onDecode: (const unsigned short*) str :(const char*) strType :(const char*) strMode;
-(void) OnCameraStopOrStart:(int) on;
- (void) startScanner;
- (IBAction)HomePressed;
- (IBAction)TorchPressed;
- (IBAction)keyboardPressed;
- (void) OnForground;
- (void) OnBackground;
-(void)keyboardFinished:(NSString *)vin;

@end

