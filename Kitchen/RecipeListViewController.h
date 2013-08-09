//
//  RecipeListViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 03.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeListViewController : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_productList;
    NSMutableArray *_recipeList;
}

//Outlets
@property (weak, nonatomic) IBOutlet UITextField *tbAddRecipe;

//Actions
- (IBAction)searchRecipe:(id)sender;
@end
