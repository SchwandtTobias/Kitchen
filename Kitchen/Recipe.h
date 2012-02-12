//
//  Recipe.h
//  Kitchen
//
//  Created by Tobias Schwandt on 08.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * recipe_name;
@property (nonatomic, retain) NSString * recipe_decr;
@property (nonatomic, retain) NSData * recipe_picture;
@property (nonatomic, retain) NSString * link;

@end
