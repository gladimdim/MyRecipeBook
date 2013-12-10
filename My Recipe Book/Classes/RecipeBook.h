//
//  RecipeBook.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 9/21/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodType.h"
#import "Recipe.h"

@interface RecipeBook : NSObject <NSCoding>
@property NSMutableArray *arrayOfFoodTypes;
-(void) addFoodTypeWithName:(NSString *) foodTypeName;
-(void) generateDummyStructure;
-(Recipe *) findRecipeByName:(NSString *) recipeName;
@end
