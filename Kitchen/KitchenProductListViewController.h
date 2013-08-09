//
//  KitchenProductListViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 08.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KitchenProductListViewController : UITableViewController<UITextFieldDelegate>
{
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_productsInKitchen;
    
    int _badgeAttentionCounter;
}
@property (weak, nonatomic) IBOutlet UITextField *insertTextField;
@end
