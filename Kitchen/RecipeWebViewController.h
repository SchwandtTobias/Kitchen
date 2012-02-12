//
//  RecipeWebViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 11.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeWebViewController : UIViewController
{
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_productList;
}

@property (weak, nonatomic) IBOutlet UIWebView *webViewRecipe;
- (IBAction)refreshPage:(id)sender;
@end
