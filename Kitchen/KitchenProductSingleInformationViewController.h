//
//  KitchenProductSingleInformationViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 09.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface KitchenProductSingleInformationViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Product *productInformation;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (retain, nonatomic) UIDatePicker *datePickerKeyboard;


@property (weak, nonatomic) IBOutlet UITextField *productName;
@property (weak, nonatomic) IBOutlet UITextField *productFinDate;

- (IBAction)deleteProduct:(id)sender;
- (IBAction)intoBasket:(id)sender;
- (IBAction)doneEditing:(id)sender;
@end
