//
//  KitchenProductListViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 08.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "KitchenProductListViewController.h"
#import "KitchenProductSingleInformationViewController.h"
#import "AppDelegate.h"

#import "PropertieManager.h"
#import "Product.h"

@implementation KitchenProductListViewController
@synthesize insertTextField = _insertTextField;


- (void)setBadgesOnStart
{
    PropertieManager *pManager = [[PropertieManager alloc] init];
    
    NSString *badgeAttention = [pManager valueForKey:@"badgeAttention" InFile:@"app_informations"];
    if (![badgeAttention isEqualToString:@"0"]) {
        [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:badgeAttention];
    }
    
    NSString *badgeBasket = [pManager valueForKey:@"badgeBasket" InFile:@"app_informations"];
    if (![badgeBasket isEqualToString:@"0"]) {
        [[[[[self tabBarController] viewControllers] objectAtIndex:3] tabBarItem] setBadgeValue:badgeBasket];
    }
}


- (void) refreshBadge
{   
    NSString *badgeValue = [NSString stringWithFormat:@"%i", _badgeAttentionCounter];
    
    PropertieManager *pManager = [[PropertieManager alloc] init];
    [pManager setValue:badgeValue forKey:@"badgeAttention" InFile:@"app_informations"];
    
    //Set
    if (_badgeAttentionCounter == 0) {
        badgeValue = nil;
    }
    [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:badgeValue];
}


- (void)getData
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchBatchSize:32];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"product_date_fin" ascending:YES];
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"product_name" ascending:NO];
    NSArray *sortArray = [NSArray arrayWithObjects:sort1, sort2, nil];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    _productsInKitchen = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    _badgeAttentionCounter = 0;
    for (Product *product in _productsInKitchen) {
        if (!([product.product_date_fin timeIntervalSinceNow] > 0 || [product.product_date_fin timeIntervalSince1970] == 0))
        {
            ++_badgeAttentionCounter;
        }
    }
    
    if(error)
    {
        NSLog(@"Error in DB Request: %@", [error description]);
    }
}

- (void)insertDataWithProduct:(NSString*)product_name
{
    if([product_name length] == 0) return;
    
    //Add product to list
    Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    newProduct.product_name = product_name;
    newProduct.date_add = [NSDate date];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"Error in DB Insert: %@", [error description]);
    }

    //[TestFlight passCheckpoint:@"KITCHEN TABLE: add product"];
    
    [self getData];
    [self.tableView reloadData];
}


- (void)editingDone {
    self.navigationItem.rightBarButtonItem = nil;
    
    if ([[_insertTextField text] length] == 0) {
        [_insertTextField resignFirstResponder];
    }
    else
    {
        [_insertTextField becomeFirstResponder];
    }
    [self insertDataWithProduct:_insertTextField.text];
    _insertTextField.text = @"";
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self editingDone];
    return YES;
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
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set badges
    [self setBadgesOnStart];
}

- (void)viewDidUnload
{
    [self setInsertTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    _managedObjectContext = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData];
    [self.tableView reloadData];
    
    //Badge reloadi
    [self refreshBadge];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_productsInKitchen count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KitchenProductsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Product *productInCell = [_productsInKitchen objectAtIndex:indexPath.row];
    cell.textLabel.text = productInCell.product_name;
    
    NSString *detailText = @"Kein Ablaufdatum angegeben.";
    
    NSDate *date = productInCell.product_date_fin;
    if ([date timeIntervalSince1970] != 0)
    {
        int t1 = [date timeIntervalSinceNow];
        int daysBetween = (int)((double)t1/(3600.0*24.00));
        
        if(daysBetween < 2)
        {
            if(daysBetween >= -2)
            {
                detailText = @"Läuft demnächst ab.";
            }
            else
            {
                detailText = [NSString stringWithFormat:@"Seit etwa %i Tagen abgelaufen.", -daysBetween]; 
            }
        }   
        else
        {
            detailText = [NSString stringWithFormat:@"Noch etwa %i Tage haltbar.", daysBetween];
        }
    }
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    cell.detailTextLabel.text = detailText;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *productInCell = [_productsInKitchen objectAtIndex:indexPath.row];
    NSDate *date = productInCell.product_date_fin;
    
    UIColor *color = [UIColor grayColor];
    if ([date timeIntervalSince1970] != 0)
    {
        color = [UIColor redColor];
        
        int t1 = [date timeIntervalSinceNow];
        int daysBetween = (int)((double)t1/(3600.0*24.00));
        
        if(daysBetween > -2)
        {
            if(daysBetween < 3)
            {
                color = [UIColor orangeColor];
            }
            else
            {
                color = [UIColor colorWithRed:(40./255.0) green:(150./255.0) blue:(0./255.0) alpha:1.0];
            }
        }   
    }
    [cell.detailTextLabel setTextColor:color];
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
    if ([[segue identifier] isEqualToString:@"KitchenProductToSingleSegue"]) {
        [_insertTextField resignFirstResponder];
        [_insertTextField setText:@""];
        
        KitchenProductSingleInformationViewController *detail = [segue destinationViewController];
        NSIndexPath *index = [[[segue sourceViewController] tableView] indexPathForCell:sender];
        Product *product = [_productsInKitchen objectAtIndex:index.row];
        detail.productInformation = product;
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
@end
