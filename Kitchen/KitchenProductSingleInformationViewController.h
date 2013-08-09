//
//  KitchenProductSingleInformationViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 09.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface KitchenProductSingleInformationViewController : UITableViewController<UIAlertViewDelegate, UITextFieldDelegate>
{
    NSManagedObjectContext  *_managedObjectContext;
    UIBarButtonItem* _swapBarButtonItem;
}

@property (strong, nonatomic) Product *productInformation;

@property (retain, nonatomic) UIDatePicker *datePickerKeyboard;

@property (weak, nonatomic) IBOutlet UITextField *productName;
@property (weak, nonatomic) IBOutlet UITextField *productFinDate;

- (IBAction)deleteProduct:(id)sender;
- (IBAction)intoBasket:(id)sender;
@end
