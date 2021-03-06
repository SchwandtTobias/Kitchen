//
//  BasketProduct.h
//  Kitchen
//
//  Created by Tobias Schwandt on 05.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BasketProduct : NSManagedObject

@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSNumber * is_inside;
@property (nonatomic, retain) NSNumber * product_amount;
@property (nonatomic, retain) NSString * product_dimension;
@property (nonatomic, retain) NSString * product_name;

@end
