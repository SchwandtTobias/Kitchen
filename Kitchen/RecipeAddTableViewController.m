//
//  RecipeAddTableViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "RecipeAddTableViewController.h"
#import "AppDelegate.h"


@implementation RecipeAddTableViewController
@synthesize recipe = __recipe;

@synthesize recipeName;
@synthesize recipeCategory;
@synthesize recipePicture;
@synthesize recipeDuration;
@synthesize recipeContent;
@synthesize pictureAddIndicator;



- (BOOL) deleteImageWithUrl:(NSString *)_path
{
    NSError *error;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    [fileManger removeItemAtPath:_path error:&error];
    
    if (error) 
    {
        NSLog(@"Error while deleting old image: %@", [error description]);
        return NO;
    }
    return YES;
}


- (BOOL)saveRecipeWithName:(NSString *)_name AndCategory:(NSString *)_cat AndDuration:(NSString *)_duration AndContent:(NSString *)_content AndImage:(NSString *)_image
{
    if ([_name length] == 0) {
        return NO;
    }
    
    [__recipe setRecipe_name:_name];
    [__recipe setRecipe_category:_cat];
    [__recipe setRecipe_duration:_duration];
    [__recipe setRecipe_decr:_content];
    [__recipe setRecipe_picture:_image];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error while saving recipe: %@", [error description]);
        return NO;
    }
    
    return YES;
}

- (BOOL)saveRecipeComplete
{
    NSString *filePath = [__recipe recipe_picture];
    
    if (imageChanged) 
    {
        //Delete old picture
        if ([self deleteImageWithUrl:[__recipe recipe_picture]]) 
        {
            //Save image
            NSData *imageData = UIImagePNGRepresentation([self.recipePicture image]); 
            
            NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
            NSString *documentsPath = [pathArray objectAtIndex:0];
            filePath = [documentsPath stringByAppendingPathComponent:[self.recipeName text]];
            
            [imageData writeToFile:filePath atomically:YES];
        }
    }
    
    //Save core data
    return [self saveRecipeWithName:[self.recipeName text] 
                        AndCategory:[self.recipeCategory text] 
                        AndDuration:[self.recipeDuration text] 
                         AndContent:[self.recipeContent text] 
                           AndImage:filePath];
}


- (void)deleteRecipeComplete
{
    //Delete image
    if ([self deleteImageWithUrl:[__recipe recipe_picture]]) {
        [_managedObjectContext deleteObject:__recipe];
        
        NSError *error;
        [_managedObjectContext save:&error];
        if (error) {
            NSLog(@"Error delete recipe core data: %@", [error description]);
        }
        else
        {
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}


- (void)editRecipeContentComplete
{
    [self.recipeContent resignFirstResponder];
    [self saveRecipeComplete];
}


#pragma mark - text field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self saveRecipeComplete]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - text view delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _swapBarItem = [self.navigationItem rightBarButtonItem];
    
    UIBarButtonItem *doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editRecipeContentComplete)];
    [self.navigationItem setRightBarButtonItem:doneBt];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_swapBarItem != nil) {
        [self.navigationItem setRightBarButtonItem:_swapBarItem];
        _swapBarItem = nil;
    }
}


#pragma mark - image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.recipePicture setImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    //[TestFlight passCheckpoint:@"RECIPE ADD: changed image"];
    
    imageChanged = YES;
    [self saveRecipeComplete];
}

#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 0) 
    {
        if (buttonIndex == 1) {
            [self deleteRecipeComplete];
        }
    }
    else if ([alertView tag] == 1) 
    {
        if (buttonIndex == 1) 
        {
            [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self.navigationController presentModalViewController:_imagePicker animated:YES];
        }
        else if (buttonIndex == 2)
        {
            [_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self.navigationController presentModalViewController:_imagePicker animated:YES];
        }
    }
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    //Set ui
    [self.recipeName setText:[__recipe recipe_name]];
    [self.recipeCategory setText:[__recipe recipe_category]];
    [self.recipeContent setText:[__recipe recipe_decr]];
    [self.recipeDuration setText:[__recipe recipe_duration]];
    
    if ([[__recipe recipe_picture] length] > 0) {
        NSData *imgData = [NSData dataWithContentsOfFile:[__recipe recipe_picture]];
        UIImage *image = [UIImage imageWithData:imgData];
        
        [self.recipePicture setImage:image];
    }
    
    imageChanged = NO;
    
    //Set core data
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
}

- (void)viewDidUnload
{
    [self setRecipeName:nil];
    [self setRecipeContent:nil];
    [self setRecipeCategory:nil];
    [self setRecipePicture:nil];
    [self setRecipeDuration:nil];
    [self setPictureAddIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    _swapBarItem = nil;
    _managedObjectContext = nil;
    _imagePicker = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addPicture:(id)sender {
    //Image picker
    [pictureAddIndicator startAnimating];
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES; 
    }
    [pictureAddIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foto aufnehmen" message:@"Wie möchten Sie ihr Foto aufnehmen?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Kamera", @"Bibliothek", nil];
    
    [alert setTag:1];
    
    [alert show];
}

- (IBAction)deleteRecipe:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rezept löschen" message:@"Wollen Sie das Rezept wirklich löschen?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Löschen", nil];
    
    [alert setTag:0];
    
    [alert show];
}
@end
