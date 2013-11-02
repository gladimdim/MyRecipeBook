//
//  FoodTypes.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodType.h"
#import "Recipe.h"

@interface FoodType()
@end

@implementation FoodType

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayOfRecipes forKey:@"arrayOfRecipes"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.arrayOfRecipes = [aDecoder decodeObjectForKey:@"arrayOfRecipes"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

-(void) addRecipeWithName:(NSString *)name {
    Recipe *recipe = [[Recipe alloc] init];
    recipe.name = name;
    recipe.duration = @"20m";
    recipe.portions = @2;
    recipe.arrayOfIngridients = [NSMutableArray array];
    [self.arrayOfRecipes addObject:recipe];
}

@end
