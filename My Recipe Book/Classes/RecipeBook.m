//
//  RecipeBook.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 9/21/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeBook.h"

@implementation RecipeBook

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayOfFoodTypes forKey:@"arrayOfFoodTypes"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.arrayOfFoodTypes = [aDecoder decodeObjectForKey:@"arrayOfFoodTypes"];
    }
    return self;
}

-(void) addFoodType:(NSString *)foodTypeName {
    if (foodTypeName) {
        NSMutableDictionary *dictToAdd = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:foodTypeName];
        [self.arrayOfFoodTypes addObject:dictToAdd];
    }
}
@end
