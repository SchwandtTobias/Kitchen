//
//  AttentionProductListViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 11.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface AttentionProductListViewController : UITableViewController
{
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_productsAttention;
}

@end
