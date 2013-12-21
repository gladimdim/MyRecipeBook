//
//  RecipeBook.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 9/21/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeBook.h"
#import "Ingridient.h"
#import "Recipe.h"
#import "FoodType.h"
#import "Utilities.h"

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

-(void) addFoodTypeWithName:(NSString *)foodTypeName {
    if (foodTypeName) {
        FoodType *foodType = [[FoodType alloc] init];
        foodType.name = foodTypeName;
        foodType.arrayOfRecipes = [NSMutableArray array];
        [self.arrayOfFoodTypes addObject:foodType];
    }
}

-(void) generateDummyStructure {
    
    FoodType *type1 = [[FoodType alloc] init];
    type1.name = NSLocalizedString(@"Meat", nil);
    type1.arrayOfRecipes = [NSMutableArray array];
    
    FoodType *type2 = [[FoodType alloc] init];
    type2.name = NSLocalizedString(@"Soups", nil);
    type2.arrayOfRecipes = [NSMutableArray array];
    
    FoodType *type3 = [[FoodType alloc] init];
    type3.name = NSLocalizedString(@"Salads", nil);
    type3.arrayOfRecipes = [NSMutableArray array];
    
    Recipe *recipeSalad = [Recipe recipeWithName:NSLocalizedString(@"Spinach with mushrooms", nil) stepsToCook:@""];
    Ingridient *ingrSpinach = [[Ingridient alloc] init];
    ingrSpinach.nameIngridient = NSLocalizedString(@"Spinach", nil);
    ingrSpinach.amount = NSLocalizedString(@"3 handfuls", nil);
    ingrSpinach.color = [Utilities colorForCategory:0];

    Ingridient *ingrMeat = [[Ingridient alloc] init];
    ingrMeat.nameIngridient = NSLocalizedString(@"Bacon", nil);
    ingrMeat.amount = NSLocalizedString(@"3.5ounces", nil);
    ingrMeat.color = [Utilities colorForCategory:0];
    
    Ingridient *ingrMushRooms = [[Ingridient alloc] init];
    ingrMushRooms.nameIngridient = NSLocalizedString(@"Mushrooms", nil);
    ingrMushRooms.amount = NSLocalizedString(@"7ounces", nil);
    ingrMushRooms.color = [Utilities colorForCategory:0];
    
    Ingridient *ingrEggs = [[Ingridient alloc] init];
    ingrEggs.nameIngridient = NSLocalizedString(@"Hard-boiled eggs", nil);
    ingrEggs.amount = @"3";
    ingrEggs.color = [Utilities colorForCategory:0];

    Ingridient *ingrOil = [[Ingridient alloc] init];
    ingrOil.nameIngridient = NSLocalizedString(@"Olive oil", nil);
    ingrOil.amount = NSLocalizedString(@"3 spoons", nil);
    ingrOil.color = [Utilities colorForCategory:1];
    
    Ingridient *ingrWine = [[Ingridient alloc] init];
    ingrWine.nameIngridient = NSLocalizedString(@"Red wine vinegar", nil);
    ingrWine.amount = NSLocalizedString(@"3 spoons", nil);
    ingrWine.color = [Utilities colorForCategory:1];
    
    Ingridient *ingrMustard = [[Ingridient alloc] init];
    ingrMustard.nameIngridient = NSLocalizedString(@"Mustard", nil);
    ingrMustard.amount = NSLocalizedString(@"2 spoons", nil);
    ingrMustard.color = [Utilities colorForCategory:1];
    
    Ingridient *ingrPepper = [[Ingridient alloc] init];
    ingrPepper.nameIngridient = NSLocalizedString(@"Pepper/salt", nil);
    ingrPepper.color = [Utilities colorForCategory:1];
    
    recipeSalad.arrayOfIngridients = [NSMutableArray arrayWithObjects:ingrMeat, ingrMushRooms, ingrSpinach, ingrEggs, ingrOil, ingrWine, ingrMustard, ingrPepper, nil];
    
    recipeSalad.stepsToCook = NSLocalizedString(@"MUSHROOMS_STEPS_TO_COOK", nil);
    recipeSalad.portions = @2;
    recipeSalad.duration = NSLocalizedString(@"4m", nil);
    
    [type3.arrayOfRecipes addObject:recipeSalad];
    self.arrayOfFoodTypes = [NSMutableArray arrayWithObjects:type1, type2, type3, nil];
}

-(Recipe *) findRecipeByName:(NSString *)recipeName {
    for (int i = 0; i < [self.arrayOfFoodTypes count]; i++) {
        FoodType *type = (FoodType *) [self.arrayOfFoodTypes objectAtIndex:i];
        for (Recipe *rec in type.arrayOfRecipes) {
            if ([rec.name isEqualToString:recipeName]) {
                return rec;
            }
        }
    }
    return nil;
}

-(FoodType *) containsFoodTypeByName:(NSString *)foodTypeName {
    for (FoodType *type in self.arrayOfFoodTypes) {
        if ([type.name isEqualToString:foodTypeName]) {
            return type;
        }
    }
    return nil;
}

@end
