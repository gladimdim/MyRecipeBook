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

@interface FoodTypes()
@end

@implementation FoodTypes
-(NSMutableArray *) generateFoodTypes {
    Ingridient *ingrMeat = [[Ingridient alloc] init];
    ingrMeat.nameIngridient = @"Meat";
    ingrMeat.amount = @1;
    ingrMeat.unitOfMeasure = @"kg";
    
    Ingridient *ingrEggs = [[Ingridient alloc] init];
    ingrEggs.nameIngridient = @"Eggs";
    ingrEggs.amount = @5;
    ingrEggs.unitOfMeasure = @"units";
                            
    Recipe *recipeFriedMeat = [[Recipe alloc] init];
    recipeFriedMeat.arrayOfIngridients = [NSMutableArray arrayWithObjects:ingrMeat, ingrEggs, nil];
    recipeFriedMeat.name = @"Smashed meat";
    recipeFriedMeat.description = @"Smashed meat by the hammer";
    recipeFriedMeat.stepsToCook = @"Take meat\n Take pan\n Put meat into pan\n";
    NSMutableDictionary *fried = [NSMutableDictionary dictionaryWithObject:@[recipeFriedMeat, recipeFriedMeat] forKey:@"Fried"];
    NSMutableDictionary *boiled = [NSMutableDictionary dictionaryWithObject:@[recipeFriedMeat] forKey:@"Boiled"];
    NSMutableArray *meatTypes = [NSMutableArray arrayWithObjects:fried, boiled, nil];
    NSMutableDictionary *dictMeat = [NSMutableDictionary dictionaryWithObject:meatTypes forKey:@"Meat"];
    self.arrayFoodCategories = [NSMutableArray arrayWithObject:dictMeat];
    return self.arrayFoodCategories;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayFoodCategories forKey:@"foodTypes"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.arrayFoodCategories = [aDecoder decodeObjectForKey:@"foodTypes"];
    }
    return self;
}

@end
