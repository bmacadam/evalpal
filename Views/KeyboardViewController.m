//
//  KeyboardViewController.m
//  evalpal
//
//  Created by Bill MacAdam on 5/3/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "KeyboardViewController.h"
#import "ViewController.h"
#import "vin_check.h"

@interface KeyboardViewController ()

@end

@implementation KeyboardView

- (BOOL) enableInputClicksWhenVisible
{
	return YES;
}

- (void)playKeyboardClick
{
    [[UIDevice currentDevice] playInputClick];
}

@end

@implementation KeyboardViewController

@synthesize keyboardInput;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (rect.size.height / rect.size.width <= 1.5)
        nibNameOrNil = @"KeyboardViewController35";
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
//    keyboardInput.delegate = self;
    KeyboardView *view = [[KeyboardView alloc] init];
    [keyboardInput setInputView:view];

    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Scanning" style: UIBarButtonItemStylePlain target:self action:@selector(returnToScanner)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Enter VIN" ];
    //[navItem setBackBarButtonItem:backButton];
    [navBar pushNavigationItem:navItem animated:NO ];
    navBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)isLandscape
{
    return YES;
}

#pragma mark - Keystroke handlers

- (IBAction)vinKeyPressed:(id)sender
{
    AudioServicesPlaySystemSound(0x450);
    
    int loc;
	UITextRange *range;
	UITextPosition *newPos;
	
	if ([sender tag] == 100) {
		// backspace
		range = keyboardInput.selectedTextRange;
        if (range == nil) {
            keyboardInput.text = keyboardInput.text.length > 0 ? [keyboardInput.text substringToIndex:keyboardInput.text.length-1] : @"";    
        } else {
            loc = [keyboardInput offsetFromPosition:keyboardInput.beginningOfDocument toPosition:range.start];
		
            keyboardInput.text = [NSString stringWithFormat:@"%@%@", [keyboardInput.text substringToIndex:loc > 0 ? loc - 1 : 0], [keyboardInput.text substringFromIndex:loc]];
		
            newPos = [keyboardInput positionFromPosition:keyboardInput.beginningOfDocument offset:loc > 0 ? loc - 1 : 0];
		
            keyboardInput.selectedTextRange = [keyboardInput textRangeFromPosition:newPos toPosition:newPos];
        }
	}
	else if ([sender tag] == 101)
	{
		// Done
		[keyboardInput resignFirstResponder];
	}
	else
	{
		range = keyboardInput.selectedTextRange;
        if (range == nil){
            keyboardInput.text = [NSString stringWithFormat:@"%@%@", keyboardInput.text, [sender currentTitle] ];
        } else {
            loc = [keyboardInput offsetFromPosition:keyboardInput.beginningOfDocument toPosition:range.start];
            
            keyboardInput.text = [NSString stringWithFormat:@"%@%@%@", [keyboardInput.text substringToIndex:loc], [sender currentTitle], [keyboardInput.text substringFromIndex:loc]];
            
            newPos = [keyboardInput positionFromPosition:keyboardInput.beginningOfDocument offset:loc + 1];
            
            keyboardInput.selectedTextRange = [keyboardInput textRangeFromPosition:newPos toPosition:newPos];
        }
	}

    if (keyboardInput.text.length < 10)
        [decodeButton setEnabled:NO];
    else
        [decodeButton setEnabled:YES];
    
//	if ([sender tag] == VINKBD_BACKSPACE_TAG)
//		return;
//	[self positionAndShowPopupOverButton:(UIButton *)sender];
//	[self positionAndShowLabelOverButton:(UIButton *)sender];
}

- (IBAction)vinKeyReleased:(id)sender
{
//	[self hideAllPopups];
//	if (delegate != nil)
//		[delegate vinKeyPressed:sender];
}

- (IBAction)vinKeyCancelled:(id)sender
{
//	[self hideAllPopups];
}

- (IBAction)vinBackspaceKeyReleased:(id)sender
{
//	if (delegate != nil)
//		[delegate vinKeyPressed:sender];
}

- (BOOL)resignFirstResponder
{
	if (![keyboardInput isFirstResponder])
		return TRUE;
	//[keyboardInput setEditable:NO];
	return [keyboardInput resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    //return YES;
    
	if ([keyboardInput isFirstResponder])
		return TRUE;
	//[keyboardInput setEditable:YES];
	return [keyboardInput becomeFirstResponder];
}


- (void)viewDidUnload {
    [self setKeyboardInput:nil];
    [super viewDidUnload];
}

- (IBAction)decodeButtonPressed:(UIButton *)sender {
    NSString *vinString = [keyboardInput text];
    
    vin_check_result_t check = vin_check([vinString UTF8String]);
    if (check != VIN_CHECK_VALID && check != VIN_CHECK_TEN_PLUS_CHARS)
    {
        // display error message
        return;
    }

    ViewController *parent = (ViewController*)[self presentingViewController];
    [parent keyboardFinished:vinString];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)returnToScanner {
    ViewController *parent = (ViewController*)[self presentingViewController];
    [parent keyboardFinished:@""];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self returnToScanner];
    return YES;
}

@end
