//
//  AttentionProductListViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 11.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "AttentionProductListViewController.h"
#import "AppDelegate.h"
#import "KitchenProductSingleInformationViewController.h"

#import "PropertieManager.h"


@implementation AttentionProductListViewController


- (void) refreshBadge
{   
    NSString *badgeValue = [NSString stringWithFormat:@"%i", [_productsAttention count]];
    
    PropertieManager *pManager = [[PropertieManager alloc] init];
    [pManager setValue:badgeValue forKey:@"badgeAttention" InFile:@"app_informations"];
    
    //Set
    if ([_productsAttention count] == 0) {
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
    NSArray *sortArray = [NSArray arrayWithObject:sort1];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    _productsAttention = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    for (Product *product in _productsAttention) 
    {
        if ([product.product_date_fin timeIntervalSinceNow] > 0 || [product.product_date_fin timeIntervalSince1970] == 0) 
        {
            [_productsAttention removeObject:product];
        }
    }
    
    if(error)
    {
        NSLog(@"Error in DB Request: %@", [error description]);
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData];
    [self.tableView reloadData];
    
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
    return [_productsAttention count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttentionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Product *productInCell = [_productsAttention objectAtIndex:indexPath.row];
    cell.textLabel.text = productInCell.product_name;
    
    
    NSString *detailText = @"Abgelaufen";
    
    int t1 = [productInCell.product_date_fin timeIntervalSinceNow];
    int daysBetween = (int)((double)t1/(3600.0*24.00));
      
    if (daysBetween < 0)
    {
        if(daysBetween == -1)
        {
            detailText = @"Gestern abgelaufen.";
        }
        else
        {
            detailText = [NSString stringWithFormat:@"Seit %i Tagen abgelaufen.", -daysBetween];
        }
    }
    else
    {
        detailText = @"Heute abgelaufen.";
    }
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    cell.detailTextLabel.text = detailText;
    
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
    if ([[segue identifier] isEqualToString:@"AttentionToSingleSegue"]) {
        KitchenProductSingleInformationViewController *detail = [segue destinationViewController];
        NSIndexPath *index = [[[segue sourceViewController] tableView] indexPathForCell:sender];
        Product *product = [_productsAttention objectAtIndex:index.row];
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
