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


@implementation BasketProductListViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize productsInBasket = _productsInBasket;

@synthesize insertTextField = _insertTextField;
@synthesize editingDoneBarButton = _editingDoneBarButton;


- (void) alertForAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aktion" message:@"Was soll mit den ausgewählten Produkten passieren?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Löschen", @"In Küche ablegen", @"Küche und Löschen", nil];
    
    [alert show];
}

- (void)getData
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BasketProduct" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchBatchSize:32];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"is_inside" ascending:YES];
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"product_name" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sort1, sort2, nil];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    NSError *error;
    _productsInBasket = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(error)
    {
        NSLog(@"Error in DB Request: %@", [error description]);
    }
}

- (void)deleteProduct:(BasketProduct *)product
{
    
    [_managedObjectContext deleteObject:product];
    
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"Error during delete object %@", [error description]);
    }
    else
    {
        [self getData];
        [self.tableView reloadData];
    }
}


- (void)addIntoKitchenProduct:(BasketProduct *)product
{
    Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    newProduct.product_name = product.product_name;
    newProduct.date_add = [NSDate date];
    
    NSError *error;
    [_managedObjectContext save:&error];
    if(error)
    {
        NSLog(@"Error during add product to kitchen: %@", [error description]);
    }
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
    newProduct.product_amount = [NSNumber numberWithInt:1];
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
    }
}


- (void)editingDone {
    self.navigationItem.rightBarButtonItem = nil;
    
    [_insertTextField resignFirstResponder];
    [self insertDataWithProduct:_insertTextField.text];
    _insertTextField.text = @"";
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = _editingDoneBarButton;
    return YES;
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
    
    _insertTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 14, 185, 30)];
    _insertTextField.delegate = self; 
    
    _insertTextField.placeholder = @"Produkt hinzufügen.";
    
    [_insertTextField setReturnKeyType:UIReturnKeyDone];
    
    [_insertTextField setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    
    //Create BarButton Item
    _editingDoneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editingDone)];
    [_editingDoneBarButton setStyle:UIBarButtonItemStyleDone];
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
    return [_productsInBasket count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if(indexPath.row == 0)
    {
        //Add TextField
        [[cell contentView] addSubview:_insertTextField];
        
        //Set Style for this row
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.textLabel.text = @"";
    }
    else
    {
        BasketProduct *productInCell = [_productsInBasket objectAtIndex:indexPath.row - 1];
        cell.detailTextLabel.text = productInCell.product_name;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", productInCell.product_amount, productInCell.product_dimension];
        
        
        //Add Checkbox to cell
        BasketCheckBoxUIControl *checkBox;
        if([[[cell contentView] subviews] count] > 2)
        {
            checkBox = [[[cell contentView] subviews] lastObject];
        }
        else
        {
            checkBox = [[BasketCheckBoxUIControl alloc] initWithFrame:CGRectMake(20, 10, 25, 21)];
            [[cell contentView]addSubview: checkBox];
        }
        
        if (productInCell.is_inside == [NSNumber numberWithInt:1]) {
            [checkBox setCheckBoxTo:YES];
        }
        else
        {
            [checkBox setCheckBoxTo:NO];
        }
            
        [checkBox setRowNumber: indexPath.row - 1];
        [checkBox addTarget:self action:@selector(checkProductOnPosition:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    BasketProductSingleViewController *detail = [[self storyboard] instantiateViewControllerWithIdentifier:@"BasketProductSingleView"];
    detail.productInformation = [_productsInBasket objectAtIndex:indexPath.row - 1];
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actionBarButton:(id)sender {
    [self alertForAction];
}
@end
