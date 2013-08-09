//
//  Product.h
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSDate * date_add;
@property (nonatomic, retain) NSDate * product_date_fin;
@property (nonatomic, retain) NSString * product_name;
@property (nonatomic, retain) NSString * product_picture;

@end
