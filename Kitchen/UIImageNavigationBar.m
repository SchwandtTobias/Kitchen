//
//  UIImageNavigationBar.m
//  Kitchen
//
//  Created by Tobias Schwandt on 15.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "UIImageNavigationBar.h"

@implementation UIImageNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"NavigationBar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
