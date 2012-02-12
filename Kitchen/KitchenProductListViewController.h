//
//  KitchenProductListViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 08.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KitchenProductListViewController : UITableViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *productsInKitchen;

@property (strong, nonatomic) UITextField *insertTextField;
@property (strong, nonatomic) UIBarButtonItem *editingDoneBarButton;
@end
