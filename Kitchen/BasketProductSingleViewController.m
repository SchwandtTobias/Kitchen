//
//  BasketProductSingleViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 11.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "BasketProductSingleViewController.h"
#import "AppDelegate.h"

@implementation BasketProductSingleViewController
@synthesize productInformation = _productInformation;

@synthesize productName;
@synthesize productAmount;
@synthesize productDim;


- (void) alertBeforeDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Löschen" message:@"Wollen Sie das Produkt wirklich löschen?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Löschen", nil];
    
    [alert show];
}


- (void) saveProduct
{
    _productInformation.product_name = productName.text;
    _productInformation.product_dimension = productDim.text;
    _productInformation.product_amount = [NSNumber numberWithInt:[productAmount.text intValue]];
    _productInformation.is_inside = [NSNumber numberWithInt:0];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error during save: %@", [error description]);
    }
    else
    {
        [productAmount resignFirstResponder];
        [productDim resignFirstResponder];
        [productName resignFirstResponder];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) deleteProductInData
{
    [_managedObjectContext deleteObject:_productInformation];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"Error during delete: %@", [error description]);
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteProductInData];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    //Get ObjectContext
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
    
    //Set data from prev view
    productName.text = _productInformation.product_name;
    productAmount.text = [_productInformation.product_amount stringValue];
    productDim.text = _productInformation.product_dimension;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setProductName:nil];
    [self setProductAmount:nil];
    [self setProductDim:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)deleteProductInBasket:(id)sender {
    [self alertBeforeDelete];
}

- (IBAction)editingDone:(id)sender {
    [self saveProduct];
}
@end
