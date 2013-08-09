//
//  RecipeListViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 03.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "RecipeListViewController.h"
#import "RecipeAddTableViewController.h"
#import "AppDelegate.h"

#import "Product.h"


@implementation RecipeListViewController
@synthesize tbAddRecipe;


- (void)getDataProducts
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchBatchSize:32];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"product_date_fin" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sort1];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    _productList = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(error)
    {
        NSLog(@"Error in DB Request: %@", [error description]);
    }
}


- (void)getDataRecipes
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchBatchSize:32];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"recipe_name" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sort1];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    _recipeList = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(error)
    {
        NSLog(@"Error in DB Request: %@", [error description]);
    }
}


- (BOOL)addRecipeWithName:(NSString *)_name
{
    if ([_name length] == 0) {
        return NO;
    }
    
    Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:_managedObjectContext];
    
    [newRecipe setRecipe_name:_name];
    [newRecipe setRecipe_decr:@"Wie wird das Rezept gemacht?"];
    [newRecipe setRecipe_category:@""];
    [newRecipe setRecipe_picture:nil];
    
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"An error happend while insert new recipe: %@", [error description]);
        return NO;
    }
    
    //Refresh view
    [self getDataRecipes];
    [self.tableView reloadData];
    [tbAddRecipe setText:@""];
    [tbAddRecipe resignFirstResponder];
    
    return YES;
}


- (void)openBrowserWithUrl:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

- (void)openBrowserWithString:(NSString *)urlString
{
    [self openBrowserWithUrl:[NSURL URLWithString:urlString]];
}


#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *address = @"http://mobile.chefkoch.de/ms/s0o2/Rezepte.html";
        [self openBrowserWithString:address];
    }
    else if (buttonIndex == 2) 
    {
        //Search with Products
        [self getDataProducts];
        
        NSString *attach = @"";
        for (int iProducts = 0; iProducts < [_productList count]; ++iProducts) {
            if(iProducts == 2) break;
            
            attach = [attach stringByAppendingFormat:@"%@+", [[_productList objectAtIndex:iProducts] product_name]];
        }
        
        NSString *address = [NSString stringWithFormat:@"http://mobile.chefkoch.de/ms/s0o2/%@/Rezepte.html", [attach stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:address];
        [self openBrowserWithUrl:url];
    }
}


#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self addRecipeWithName:[textField text]]) {
        [textField resignFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - View

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
}

- (void)viewDidUnload
{
    [self setTbAddRecipe:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Load data
    [self getDataRecipes];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    //show elements
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
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recipeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipeCustomCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Recipe *actRecipe = [_recipeList objectAtIndex:indexPath.row];

    UILabel *recipeName         = (UILabel *)[cell viewWithTag:100];
    UILabel *recipeCat          = (UILabel *)[cell viewWithTag:101];
    UILabel *recipeDur          = (UILabel *)[cell viewWithTag:102];
    UIImageView *recipeImage    = (UIImageView *)[cell viewWithTag:200];
    
    //recipe name
    [recipeName setText:[actRecipe recipe_name]];
    
    //recipe cat
    NSString *defCat = [actRecipe recipe_category];
    if ([[actRecipe recipe_category] length] == 0) {
        defCat = @"Keine Angabe";
    }
    [recipeCat setText:[NSString stringWithFormat:@"%@", defCat]];
    
    //recipe duration
    NSString *defDur = [actRecipe recipe_duration];
    if ([[actRecipe recipe_duration] length] == 0) {
        defDur = @"Keine Angabe";
    }
    [recipeDur setText:[NSString stringWithFormat:@"Dauer: %@", defDur]];
    
    //recipe image
    if ([[actRecipe recipe_picture] length] > 0) {
        NSData *imgData = [NSData dataWithContentsOfFile:[actRecipe recipe_picture]];
        UIImage *image = [UIImage imageWithData:imgData];
        
        [recipeImage setImage:image];
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"food_steak" ofType:@"png"]];
        [recipeImage setImage:image];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RecipeShowDetailView"]) {
        RecipeAddTableViewController *detail = [segue destinationViewController];
        NSIndexPath *index = [[[segue sourceViewController] tableView] indexPathForCell:sender];
        [detail setRecipe:[_recipeList objectAtIndex:index.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)searchRecipe:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rezeptsuche" message:@"Wollen Sie auf chefkoch.de nach Rezepten suchen?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Suchen", @"Suchen mit Produkten aus Küche", nil];
    
    [alert show];
}
@end
