//
//  CheckBoxViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 10.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasketCheckBoxUIControl : UIButton
{
    BOOL checkBoxSelected;
}

- (void)setCheckBoxTo:(BOOL)check;

@property (nonatomic) int rowNumber;
@end
