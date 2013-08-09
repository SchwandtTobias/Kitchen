//
//  PropertieWriter.h
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertieManager : NSObject

- (BOOL)savePropertiesFromDrictionary:(NSDictionary *)_dict InFile:(NSString *)_filename;
- (NSMutableDictionary *)loadPropertiesFromFile:(NSString *)_filename;

- (void)setValue:(id)_value forKey:(NSString *)_key InFile:(NSString *)_filename;
- (id)valueForKey:(NSString *)_key InFile:(NSString *)_filename;

@end
