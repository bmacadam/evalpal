
//
//  ViewController.m
//  inigmaSDKDemo
//
//  Created by 1 1 on 4/1/12.
//  Copyright (c) 2012 1. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>

#import "ViewController.h"
#import "WebAppController.h"
#import "vin_check.h"

void WrapError(void* pThis,const char* str)
{
	ViewController* p = (__bridge ViewController*)pThis;
	[p onError:str];
	
}
void WrapNotify(void* pThis,const char* str)
{
	ViewController* p = (__bridge ViewController*)pThis;
	[p onNotify:str];
	
}
void WrapDecode(void* pThis,const unsigned short* str,const char* SymbolType,const char* SymbolMode)
{
	ViewController* p = (__bridge ViewController*)pThis;
    
	[p onDecode:str:SymbolType:SymbolMode];
}
void WrapCameraStopOrStart(int on,void* pThis)
{
	ViewController* p = (__bridge ViewController*)pThis;
	[p OnCameraStopOrStart:on];	
    if (on)
    {
        [p onError:""];
        [p onNotify:""];
    }
}


@interface ViewController ()

@end

@implementation ViewController

@synthesize parent;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - Initialization
- (id)init
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (rect.size.height / rect.size.width <= 1.5)
        self = [[ViewController alloc] initWithNibName:@"ViewController_iPhone35" bundle:nil];
    else
        self = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//    } else {
//        self = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
//    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initLocal];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	
    self = [super initWithCoder:coder];
	[self initLocal];
	
	return self;
}

/*
 If you were to create the view programmatically, you would use initWithFrame:.
 You want to make sure the placard view is set up in this case as well (as in initWithCoder:).
 */
-(void) initLocal
{
	m_pScanner = new CScanner((__bridge void*)self);
    m_bTorch = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        m_pScanner->SetOrientation(UIInterfaceOrientationLandscapeRight);
    }
    self.wantsFullScreenLayout = YES;

}

- (void)viewDidLoad {
    NSBundle *bundle = [NSBundle mainBundle];
    
    versionLabel.text = [NSString stringWithFormat:@"VERSION %@ BUILD %@",
                         [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]];
    
#if NIADA
    appLabel.text = @"NIADA Mobile";
#endif
    
}

-(void) OnCameraStopOrStart:(int) on
{
	if (on == 1){
        [self.view addSubview:topBar];
        [self.view addSubview:bottomBar];
        
        if (((CScanner*)m_pScanner)->IsTorchAvailable()){
            [self.view addSubview:TorchButton];
        }
        
        laser_layer = [CALayer layer];
        laser_layer.backgroundColor = [[UIColor clearColor] CGColor];
        laser_layer.frame = [self.view bounds];
        laser_layer.delegate = self;
        
        laser_animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        laser_animation.removedOnCompletion = NO;
        laser_animation.duration = .5;
        laser_animation.repeatCount = HUGE_VALF;
        laser_animation.autoreverses = YES;
        laser_animation.fromValue = [NSNumber numberWithFloat:1.0];
        laser_animation.toValue = [NSNumber numberWithFloat:0.25];
        laser_animation.delegate = self;
        [laser_layer addAnimation:laser_animation forKey:@"animateOpacity"];
        
        [[self.view layer] addSublayer:laser_layer];
        [laser_layer setNeedsDisplay];
        
    }
}

#pragma mark - Finalize

- (void)dealloc {
    if (m_pScanner){
        delete ((CScanner*)m_pScanner);
    }
    
	//[super dealloc];
	
}

- (void)viewDidUnload {
    appLabel = nil;
	[laser_layer removeAnimationForKey:@"animateOpacity"];
	[laser_layer removeFromSuperlayer];
    
    laser_animation.delegate = nil;
    laser_layer.delegate = nil;
    
    m_pScanner->CloseCamera();
    
}

- (void)CloseScanner:(NSTimer*)timer
{
    [self dismissViewControllerAnimated:NO completion:NULL];
    
}

#pragma mark - Rotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"Scan view orientation request");
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
    if (m_pScanner){
        ((CScanner*)m_pScanner)->SetOrientation(toInterfaceOrientation);
    }
}

- (BOOL)isLandscape
{
    return YES;
}

- (void)startScanner {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        m_pScanner->Scan((__bridge void*)self.view,30,30,720,920,30,30,920,720);
    }else{
        m_pScanner->Scan((__bridge void*)self.view,0,0,310,400,0,0,560,420);
    }
}

#pragma mark - Button actions

- (IBAction)HomePressed
{
	[[self parent] OnHome];
    
	//((CScanner*)m_pScanner)->CloseCamera();
    
    [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(CloseScanner:) userInfo:nil repeats:NO];
}

- (IBAction)TorchPressed
{
	if (m_bTorch == 0){
        m_bTorch = 1;
        ((CScanner*)m_pScanner)->TurnTorch(1);
    }else{
        m_bTorch = 0;
        ((CScanner*)m_pScanner)->TurnTorch(0);
        
    }
}

- (IBAction)keyboardPressed
{
    keyboardView = [[KeyboardViewController alloc] init];
    
    [self presentViewController:keyboardView animated:NO completion:NULL];
}

-(void)keyboardFinished: (NSString*) vin
{
    [self dismissViewControllerAnimated:NO completion:NULL];

    if ([vin isEqual: @""])
        return;
    
    // send the VIN back to the web controller
	[[self parent] setVIN:vin];
    
    [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(CloseScanner:) userInfo:nil repeats:NO];
}

-(void) onError: (const char*) str
{
	NSString *strLocal;
	strLocal = [NSString stringWithFormat:@"%s" , str];
}

-(void) onNotify: (const char*) str
{
	NSString *strLocal;
	strLocal = [NSString stringWithFormat:@"%s" , str];
}

-(void) onDecode: (const unsigned short*) str : (const char*) strType : (const char*) strMode

{
	NSString *strLocal;
	strLocal = [NSString stringWithFormat:@"%S" , str];
    
    // check for the letter "I" in the first position
    if ([strLocal characterAtIndex:0] == 'I' && [strLocal length] == 18) {
        strLocal = [strLocal substringFromIndex:1];
    }
    
    vin_check_result_t check = vin_check([strLocal UTF8String]);
    if (check != VIN_CHECK_VALID)
    {
        [self startScanner];
        return;
    }
    
    [self vibratePhone];
    
    // send the VIN back to the web controller
	[[self parent] setVIN:strLocal];
    
    [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(CloseScanner:) userInfo:nil repeats:NO];
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGPoint pts[8];
    
	pts[0].x = layer.bounds.origin.x;
	pts[0].y = layer.bounds.origin.y + layer.bounds.size.height / 2;
	pts[1].x = layer.bounds.origin.x + layer.bounds.size.width * 7 / 15;
	pts[1].y = pts[0].y;
    
	pts[2].x = layer.bounds.origin.x + layer.bounds.size.width * 8 / 15;
	pts[2].y = pts[0].y;
	pts[3].x = layer.bounds.origin.x + layer.bounds.size.width;
	pts[3].y = pts[0].y;
    
	pts[4].x = layer.bounds.origin.x + layer.bounds.size.width * 15 / 31;
	pts[4].y = pts[0].y;
	pts[5].x = layer.bounds.origin.x + layer.bounds.size.width * 16 / 31;
	pts[5].y = pts[0].y;
    
	pts[6].x = layer.bounds.origin.x + layer.bounds.size.width / 2;
	pts[6].y = layer.bounds.origin.y + layer.bounds.size.height / 2 -
    layer.bounds.size.width / 62;
	pts[7].x = pts[6].x;
	pts[7].y = layer.bounds.origin.y + layer.bounds.size.height / 2 +
    layer.bounds.size.width / 62;
    
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 1.000, 0.000, 0.082, 1.0);
	CGContextAddLines(context, &pts[0], 2);
	CGContextAddLines(context, &pts[2], 2);
	CGContextAddLines(context, &pts[4], 2);
	CGContextAddLines(context, &pts[6], 2);
	CGContextStrokePath(context);
}


- (void)OnBackground {
    ((CScanner*)m_pScanner)->OnBackground();
}

- (void)OnForground {
    ((CScanner*)m_pScanner)->OnForground();
}

- (void)vibratePhone
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
