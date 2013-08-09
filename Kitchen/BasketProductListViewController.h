//
//  BasketProductListViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 10.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasketProductListViewController : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_productsInBasket;
}

@property (weak, nonatomic) IBOutlet UITextField *insertTextField;

- (IBAction)actionBarButton:(id)sender;
@end
