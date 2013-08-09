//
//  Recipe.h
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecipeHasProducts;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * recipe_category;
@property (nonatomic, retain) NSString * recipe_decr;
@property (nonatomic, retain) NSNumber * recipe_difficulty;
@property (nonatomic, retain) NSString * recipe_duration;
@property (nonatomic, retain) NSString * recipe_name;
@property (nonatomic, retain) NSString * recipe_picture;
@property (nonatomic, retain) RecipeHasProducts *recipe_has_product;

@end
