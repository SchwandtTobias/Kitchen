//
//  RecipeAddTableViewController.h
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeAddTableViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
    NSManagedObjectContext* _managedObjectContext;
    UIImagePickerController* _imagePicker;
    
    UIBarButtonItem* _swapBarItem;
    
    BOOL imageChanged;
}

//Vars
@property (assign) Recipe *recipe;

//Actions
- (IBAction)addPicture:(id)sender;
- (IBAction)deleteRecipe:(id)sender;

//Outlets
@property (weak, nonatomic) IBOutlet UITextField *recipeName;
@property (weak, nonatomic) IBOutlet UITextField *recipeCategory;
@property (weak, nonatomic) IBOutlet UIImageView *recipePicture;
@property (weak, nonatomic) IBOutlet UITextField *recipeDuration;
@property (weak, nonatomic) IBOutlet UITextView *recipeContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pictureAddIndicator;
@end
