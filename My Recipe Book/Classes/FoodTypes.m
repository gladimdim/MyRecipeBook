//
//  FoodTypes.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodTypes.h"
#import "Recipe.h"
#import "Ingridient.h"

@implementation FoodTypes
-(NSArray *) generateFoodTypes {
    Ingridient *ingrMeat = [[Ingridient alloc] init];
    ingrMeat.nameIngridient = @"Meat";
    ingrMeat.amount = @1;
    ingrMeat.unitOfMeasure = @"kg";
    
    Ingridient *ingrEggs = [[Ingridient alloc] init];
    ingrEggs.nameIngridient = @"Eggs";
    ingrEggs.amount = @5;
    ingrEggs.unitOfMeasure = @"units";
                            
    Recipe *recipeFriedMeat = [[Recipe alloc] init];
    recipeFriedMeat.arrayOfIngridients = @[ingrMeat, ingrEggs];
    recipeFriedMeat.name = @"Smashed meat";
    recipeFriedMeat.description = @"Smashed meat by the hammer";
    NSDictionary *fried = @{@"Fried": @[recipeFriedMeat, recipeFriedMeat]};
    NSDictionary *boiled = @{@"Boiled": @[recipeFriedMeat]};
    NSArray *meatTypes = @[fried, boiled];
    NSDictionary *dictMeat = @{@"Meat": meatTypes};
    NSArray *arrayOfFoodTypes = @[dictMeat];
    return arrayOfFoodTypes;
}

@end
