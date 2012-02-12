//
//  KitchenProductSingleInformationViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 09.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "KitchenProductSingleInformationViewController.h"
#import "AppDelegate.h"
#import "BasketProduct.h"

@implementation KitchenProductSingleInformationViewController

@synthesize productInformation = _productInformation;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize datePickerKeyboard = _datePickerKeyboard;
@synthesize productName = _productName;
@synthesize productFinDate = _productFinDate;


- (void) alertBeforeDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Löschen" message:@"Wollen Sie das Produkt wirklich löschen?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Löschen", @"Einkaufskorb und Löschen", nil];
    
    [alert show];
}


- (void) saveProduct
{
    if([_productName.text length] == 0) return;
    
    _productInformation.product_name = _productName.text;
    _productInformation.product_date_fin = [_datePickerKeyboard date];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error during save: %@", [error description]);
    }
    else
    {
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

- (void) addProductToBasket
{
    BasketProduct *basketProduct = [NSEntityDescription insertNewObjectForEntityForName:@"BasketProduct" inManagedObjectContext:_managedObjectContext];
    basketProduct.product_name = _productInformation.product_name;
    basketProduct.product_amount = [NSNumber numberWithInt:1];
    basketProduct.product_dimension = @"Stk.";
    basketProduct.is_inside = [NSNumber numberWithInt:0];
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"Error during insert in basket: %@", [error description]);
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteProductInData];
    }
    else if(buttonIndex == 2) {
        [self addProductToBasket];
        [self deleteProductInData];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void) dateSelected
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, dd. MMM yyyy"];
    _productFinDate.text = [formatter stringFromDate:[_datePickerKeyboard date]];
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
    
    
    //set Information
    _productName.text = _productInformation.product_name;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, dd. MMM yyyy"];
    _productFinDate.text = [formatter stringFromDate:_productInformation.product_date_fin];
    
    //Init View for Datepicker
    _datePickerKeyboard = [[UIDatePicker alloc] init];
    [_datePickerKeyboard setDatePickerMode:UIDatePickerModeDate];
    [_datePickerKeyboard addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventValueChanged];
    
    if(_productInformation.product_date_fin)
    {
        [_datePickerKeyboard setDate:_productInformation.product_date_fin];
    }
    
    _productFinDate.inputView = _datePickerKeyboard;
    
    //Set Object Context
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = app.managedObjectContext;
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
    [self setProductFinDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)deleteProduct:(id)sender {
    [self alertBeforeDelete];
}

- (IBAction)intoBasket:(id)sender {
    [self addProductToBasket];
}

- (IBAction)doneEditing:(id)sender {
    [_productFinDate resignFirstResponder];
    [self saveProduct];
}
@end
