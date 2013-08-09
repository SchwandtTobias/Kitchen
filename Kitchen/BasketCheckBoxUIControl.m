//
//  CheckBoxViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 10.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "BasketCheckBoxUIControl.h"

@implementation BasketCheckBoxUIControl
@synthesize rowNumber = _rowNumber;
@synthesize hitOverlay = _hitOverlay;

-(id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 25, 21)];
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self=[super initWithFrame:frame]) 
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        // Image for normal state
        UIImage *newNormalImage = [UIImage imageNamed:@"glyphicons_150_uncheck.png"];
        [self setBackgroundImage:newNormalImage forState:UIControlStateNormal];

        // Image for selected state
        UIImage *newSelectedImage = [UIImage imageNamed:@"glyphicons_150_check.png"];
        [self setBackgroundImage:newSelectedImage forState:UIControlStateSelected];
        
        self.adjustsImageWhenHighlighted = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        [self addTarget:self action:@selector(checkBoxSelect) forControlEvents:UIControlEventTouchUpInside];
        
        
        _hitOverlay = 50;
    }
    return self;
}

- (void)setCheckBoxTo:(BOOL)check
{
    [self setSelected:check];
    checkBoxSelected = check;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect largerFrame = CGRectMake(self.frame.origin.x - _hitOverlay, self.frame.origin.y - _hitOverlay, self.frame.size.width + _hitOverlay, self.frame.size.height + _hitOverlay);
    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
}

- (void)checkBoxSelect
{
	if (checkBoxSelected == 0)
	{
		[self setSelected:YES];
		checkBoxSelected = 1;
	}
	else
	{
		[self setSelected:NO];
		checkBoxSelected = 0;
	}
}

@end
