//
//  Setting.h
//  Kitchen
//
//  Created by Tobias Schwandt on 08.02.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Setting : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * setting;

@end
