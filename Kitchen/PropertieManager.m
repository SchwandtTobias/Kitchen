//
//  PropertieWriter.m
//  Kitchen
//
//  Created by Tobias Schwandt on 04.03.12.
//  Copyright (c) 2012 Zebresel. All rights reserved.
//

#import "PropertieManager.h"

@implementation PropertieManager


- (BOOL)savePropertiesFromDrictionary:(NSDictionary *)_dict InFile:(NSString *)_filename
{
    //Save
    NSString *completeFilename      = [NSString stringWithFormat:@"%@.plist", _filename];
    
    NSArray *pathArray              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *pathToAppinfos        = [pathArray objectAtIndex:0];
    pathToAppinfos                  = [pathToAppinfos stringByAppendingPathComponent:completeFilename];
    
    [_dict writeToFile:pathToAppinfos atomically:YES];
    return YES;
}


- (NSMutableDictionary *)loadPropertiesFromFile:(NSString *)_filename
{
    NSString *completeFilename      = [NSString stringWithFormat:@"%@.plist", _filename];
    
    NSArray *pathArray              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *destPath              = [pathArray objectAtIndex:0];
    destPath                        = [destPath stringByAppendingPathComponent:completeFilename];
    
    //Check if file exist in bundle
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:_filename ofType:@"plist"];
        NSError *error;
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        
        NSAssert(error == nil, @"Error copy plist: %@", [error description]);
    }
    
    //Init array with content file
    NSMutableDictionary *elements = [[NSMutableDictionary alloc] initWithContentsOfFile:destPath];
    NSAssert(elements != nil, @"Building directory with content file fails");
    
    return elements;
}


- (void)setValue:(id)_value forKey:(NSString *)_key InFile:(NSString *)_filename
{
    NSMutableDictionary* dict = [self loadPropertiesFromFile:_filename];
    [dict setValue:_value forKey:_key];
    [self savePropertiesFromDrictionary:dict InFile:_filename];
}

- (id)valueForKey:(NSString *)_key InFile:(NSString *)_filename
{
    NSDictionary* dict = [self loadPropertiesFromFile:_filename];
    return [dict valueForKey:_key];
}

@end
