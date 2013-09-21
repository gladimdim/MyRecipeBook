//
//  FoodSubTypes.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 9/21/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodSubType.h"
#import "Recipe.h"

@implementation FoodSubType
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayOfRecipes forKey:@"arrayOfRecipes"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.arrayOfRecipes = [aDecoder decodeObjectForKey:@"arrayOfRecipes"];
    }
    return self;
}

@end
