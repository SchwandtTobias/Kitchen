//
//  BasketProductListViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 10.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "BasketProductListViewController.h"
#import "AppDelegate.h"
#import "BasketProduct.h"
#import "Product.h"

#import "BasketProductSingleViewController.h"
#import "BasketCheckBoxUIControl.h"
#import "PropertieManager.h"


@implementation BasketProductListViewController
@synthesize insertTextField = _insertTextField;



- (void) refreshBadge
{   
    NSString *badgeValue = [NSString stringWithFormat:@"%i", [_productsInBasket count]];
    
    PropertieManager *pManager = [[PropertieManager alloc] init];
    [pManager setValue:badgeValue forKey:@"badgeBasket" InFile:@"app_informations"];
    
    //Set
    if ([_productsInBasket count] == 0) {
        badgeValue = nil;
    }
    [[[[[self tabBarController] viewControllers] objectAtIndex:3] tabBarItem] setBadgeValue:badgeValue];
}


- (BOOL)getData
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BasketProduct" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchBatchSize:32];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"date_add" ascending:NO];
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"product_name" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sort1, sort2, nil];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    _productsInBasket = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(error)
    {
        NSLog(@"Error in DB Request: %@", [error description]);
        return NO;
    }
    return YES;
}

- (BOOL)deleteProduct:(BasketProduct *)product
{
    
    [_managedObjectContext deleteObject:product];
    
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"Error during delete object %@", [error description]);
        return NO;
    }

    [self getData];
    [self.tableView reloadData];
    
    [self refreshBadge];
    
    return YES;
}


- (BOOL)addIntoKitchenProduct:(BasketProduct *)product
{
    Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    newProduct.product_name = product.product_name;
    newProduct.date_add = [NSDate date];
    
    NSError *error;
    [_managedObjectContext save:&error];
    if(error)
    {
        NSLog(@"Error during add product to kitchen: %@", [error description]);
        return NO;
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            //Delete selected products
            for (BasketProduct *bp in _productsInBasket) {
                if([bp.is_inside intValue] == 1)
                {
                    [self deleteProduct:bp];
                }
            }
            break;
        case 2:
            //add selected products to kitchen
            for (BasketProduct *bp in _productsInBasket) {
                if([bp.is_inside intValue] == 1)
                {
                    [self addIntoKitchenProduct:bp];
                }
            }
            break;
        case 3:
            //add and delete selected products
            for (BasketProduct *bp in _productsInBasket) {
                if([bp.is_inside intValue] == 1)
                {
                    [self addIntoKitchenProduct:bp];
                    [self deleteProduct:bp];
                }
            }
            break;
        default:
            break;
    }
}

- (void) checkProductOnPosition:(id)sender
{
    BasketCheckBoxUIControl *sndButton = sender;
    BasketProduct *product = [_productsInBasket objectAtIndex:sndButton.rowNumber];
    
    if(product.is_inside == [NSNumber numberWithInt:0])
    {
        product.is_inside = [NSNumber numberWithInt:1];
    }
    else
    {
        product.is_inside = [NSNumber numberWithInt:0];
    }
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if (error) { 
        [sndButton setCheckBoxTo:NO];
        NSLog(@"Error during saving inside: %@", [error description]);
    }
    else
    {
        [self getData];
        [self.tableView reloadData];
    }
}


- (void)insertDataWithProduct:(NSString*)product_name
{
    if([product_name length] == 0) return;
    
    //Add product to list
    BasketProduct *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"BasketProduct" inManagedObjectContext:_managedObjectContext];
    newProduct.product_name = product_name;
    newProduct.product_amount = [NSNumber numberWithFloat:1.0f];
    newProduct.product_dimension = @"Stk.";
    newProduct.is_inside = [NSNumber numberWithInt:0];
    newProduct.date_add = [NSDate date];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"Error in DB Insert: %@", [error description]);
    }
    else
    {
        [self getData];
        [self.tableView reloadData];
        [self refreshBadge];
    }
}


- (void)editingDone {
    self.navigationItem.rightBarButtonItem = nil;
    
    if ([[_insertTextField text] length] == 0) {
        [_insertTextField resignFirstResponder];
    }
    else {
        [_insertTextField becomeFirstResponder];
    }
    
    [self insertDataWithProduct: [_insertTextField text]];
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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setInsertTextField:nil];
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
    return [_productsInBasket count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasketProductCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    BasketProduct *productInCell = [_productsInBasket objectAtIndex:indexPath.row];
    
    UILabel *productName    = (UILabel *)[cell viewWithTag:100];
    UILabel *productAmount  = (UILabel *)[cell viewWithTag:101];
    UIView *productCheck    = (UIView *)[cell viewWithTag:200];
    
    [productName setText:productInCell.product_name];
    [productAmount setText:[NSString stringWithFormat:@"%@ %@", productInCell.product_amount, productInCell.product_dimension]];
    
    //Checkbox
    BasketCheckBoxUIControl *checkBox;
    if([[productCheck subviews] count] > 0)
    {
        checkBox = [[productCheck subviews] lastObject];
    }
    else
    {
        checkBox = [[BasketCheckBoxUIControl alloc] initWithFrame:CGRectMake(20, 10, 25, 21)];
        [productCheck addSubview: checkBox];
    }
    
    if (productInCell.is_inside == [NSNumber numberWithInt:1]) 
    {
        [checkBox setCheckBoxTo:YES];
    }
    else
    {
        [checkBox setCheckBoxTo:NO];
    }
        
    [checkBox setRowNumber: indexPath.row];
    [checkBox addTarget:self action:@selector(checkProductOnPosition:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    [_insertTextField resignFirstResponder];
    
    if ([[segue identifier] isEqualToString:@"BasketProductInformationSegue"])
    {
        BasketProductSingleViewController *detail = [segue destinationViewController];
        NSIndexPath *index = [[[segue sourceViewController] tableView] indexPathForCell:sender];
        [detail setProductInformation:[_productsInBasket objectAtIndex:index.row]];
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

- (IBAction)actionBarButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aktion" message:@"Was soll mit den ausgewählten Produkten passieren?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Entfernen", @"In Küche ablegen", @"Küche und Entfernen", nil];
    
    [alert show];
}
@end
