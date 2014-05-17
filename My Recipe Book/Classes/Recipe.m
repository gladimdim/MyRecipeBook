//
//  Recipe.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/20/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "Recipe.h"
#import "Ingridient.h"
@implementation Recipe

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayOfIngridients forKey:@"arrayOfIngridients"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.stepsToCook forKey:@"stepsToCook"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.portions forKey:@"portions"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.arrayOfIngridients = [aDecoder decodeObjectForKey:@"arrayOfIngridients"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.description = [aDecoder decodeObjectForKey:@"description"];
        self.stepsToCook = [aDecoder decodeObjectForKey:@"stepsToCook"];
        self.duration = [aDecoder decodeObjectForKey:@"duration"];
        self.portions = [aDecoder decodeObjectForKey:@"portions"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
}

+(Recipe *) recipeWithName:(NSString *)name stepsToCook:(NSString *)stepsToCook {
    Recipe *recipe = [[Recipe alloc] init];
    recipe.name = name;
    recipe.stepsToCook = stepsToCook;
    return recipe;
}

-(NSString *) ingredientsArrayToString {
    NSMutableString *notes = [NSMutableString string];
    for (int i = 0; i < self.arrayOfIngridients.count; i++) {
        Ingridient *ingr = (self.arrayOfIngridients)[i];
        [notes appendString:[NSString stringWithFormat:@"%@ %@\n", ingr.nameIngridient, ingr.amount ? ingr.amount: @""]];
    }
    return notes;
}

@end
