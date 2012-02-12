//
//  RecipeWebViewController.m
//  Kitchen
//
//  Created by Tobias Schwandt on 11.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "RecipeWebViewController.h"
#import "AppDelegate.h"
#import "Product.h"

@implementation RecipeWebViewController
@synthesize webViewRecipe;


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
    _productList = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(error)
    {
        NSLog(@"Error in DB Request: %@", [error description]);
    }
}

- (void)refreshRequest
{
    [self getData];
    NSString *attach = @"";
    for (int iProducts = 0; iProducts < [_productList count]; ++iProducts) {
        if(iProducts == 2) break;
        
        attach = [attach stringByAppendingFormat:@"%@+", [[_productList objectAtIndex:iProducts] product_name]];
    }
    
    
    NSString *address = [NSString stringWithFormat:@"http://mobile.chefkoch.de/ms/s0o2/%@/Rezepte.html", [attach stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:address];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webViewRecipe loadRequest:request];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshRequest];
}


- (void)viewDidUnload
{
    [self setWebViewRecipe:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)refreshPage:(id)sender {
    [self refreshRequest];
}
@end
