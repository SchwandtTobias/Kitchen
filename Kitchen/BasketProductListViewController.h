//
//  BasketProductListViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 10.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasketProductListViewController : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *productsInBasket;

@property (strong, nonatomic) UITextField *insertTextField;
@property (strong, nonatomic) UIBarButtonItem *editingDoneBarButton;

- (IBAction)actionBarButton:(id)sender;
@end
