//
//  BasketProductSingleViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 11.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasketProduct.h"

@interface BasketProductSingleViewController : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSManagedObjectContext *_managedObjectContext;
}

@property (strong, nonatomic) BasketProduct *productInformation;

@property (weak, nonatomic) IBOutlet UITextField *productName;
@property (weak, nonatomic) IBOutlet UITextField *productAmount;
@property (weak, nonatomic) IBOutlet UITextField *productDim;


- (IBAction)deleteProductInBasket:(id)sender;
@end
