//
//  FoodTypesDocument.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 9/6/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodTypesDocument.h"

@implementation FoodTypesDocument

-(BOOL) loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if ([contents length] > 0) {
        self.foodTypes = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *) contents];
    }
    return YES;
}

-(id) contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    return [NSKeyedArchiver archivedDataWithRootObject:self.foodTypes];
}
@end