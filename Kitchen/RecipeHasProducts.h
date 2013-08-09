//
//  RecipeHasProducts.h
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe, RecipeProduct;

@interface RecipeHasProducts : NSManagedObject

@property (nonatomic, retain) NSString * product_name;
@property (nonatomic, retain) NSString * recipe_name;
@property (nonatomic, retain) RecipeProduct *recipe_has_product;
@property (nonatomic, retain) Recipe *product_has_recipe;

@end
