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


- (BOOL) saveProduct
{
    if ([productName.text length] == 0 || [productDim.text length] == 0 || [productAmount.text length] == 0) {
        return NO;
    }
    
    _productInformation.product_name = productName.text;
    _productInformation.product_dimension = productDim.text;
    _productInformation.product_amount = [NSNumber numberWithFloat:[productAmount.text floatValue]];
    _productInformation.is_inside = [NSNumber numberWithInt:0];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error during save: %@", [error description]);
        return NO;
    }
    
    return YES;
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
        //[TestFlight passCheckpoint:@"BASKET DETAIL: delete product"];
        [self deleteProductInData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self saveProduct];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entfernen" message:@"Wollen Sie das Produkt wirklich von der Liste streichen?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Ja", nil];
    
    [alert show];
}
@end
