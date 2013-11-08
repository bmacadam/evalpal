//
//  gpiKeyboardTextView.m
//  evalpal
//
//  Created by Bill MacAdam on 6/3/13.
//  Copyright (c) 2013 Bill MacAdam. All rights reserved.
//

#import "gpiKeyboardTextField.h"

@implementation gpiKeyboardTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
