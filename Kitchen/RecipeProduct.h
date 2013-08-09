//
//  RecipeProduct.h
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecipeHasProducts;

@interface RecipeProduct : NSManagedObject

@property (nonatomic, retain) NSNumber * product_amount;
@property (nonatomic, retain) NSString * product_dimension;
@property (nonatomic, retain) NSString * product_name;
@property (nonatomic, retain) NSString * product_picture;
@property (nonatomic, retain) RecipeHasProducts *product_has_recipe;

@end
