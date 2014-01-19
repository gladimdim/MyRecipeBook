//
//  Utilities.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 10/21/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "Utilities.h"
#import "Ingridient.h"
#import "FoodType.h"

@implementation Utilities

+(NSString *) composeEmailForRecipe:(Recipe *)recipe withHTML:(BOOL)withHTML {
    NSMutableString *resultString = [NSMutableString string];
    withHTML ? [resultString appendString:@"<h3>"] : nil;
    [resultString appendString:[NSString stringWithFormat:NSLocalizedString(@"Recipe for %@", nil), recipe.name]];
    withHTML ? [resultString appendString:@"</h3>"] : nil;
    withHTML ? [resultString appendString:@"<h4>"] : nil;
    [resultString appendString:[NSString stringWithFormat:NSLocalizedString(@"Prep time: %@", nil), recipe.duration]];
    withHTML ? [resultString appendString:@"</h4>"] : nil;
    withHTML ? [resultString appendString:@"<h4>"] : nil;
    [resultString appendString:[NSString stringWithFormat:NSLocalizedString(@"Portions: %@", nil), [recipe.portions stringValue]]];
    withHTML ? [resultString appendString:@"</h4>"] : nil;

    withHTML ? [resultString appendString:@"<p><h4>"] : [resultString appendString:@"\n"];
    [resultString appendString:NSLocalizedString(@"List of ingredients: ", nil)];
    withHTML ? [resultString appendString:@"</b></h4>"] : [resultString appendString:@"\n"];
    
    //lets make an HTML list if needed
    withHTML ? [resultString appendString:@"<ul>"] : nil;
    for (int i = 0; i < recipe.arrayOfIngridients.count; i++) {
        Ingridient *ingr = (Ingridient *) recipe.arrayOfIngridients[i];
        withHTML ? [resultString appendString:@"<li>"] : nil;
        [resultString appendString:[NSString stringWithFormat:@"%@: %@", ingr.nameIngridient ? ingr.nameIngridient : @"", ingr.amount ? ingr.amount : @""]];
        withHTML ? [resultString appendString:@"</li>"] : [resultString appendString:@"\n"];
    }
    //list ends
    withHTML ? [resultString appendString:@"</ul>"] : nil;
    withHTML ? [resultString appendString:@"<h4>"] : nil;
    [resultString appendString:NSLocalizedString(@"Description: ", nil)];
    withHTML ? [resultString appendString:@"</h4>"] : [resultString appendString:@"\n"];
    
    if (recipe.stepsToCook && ![recipe.stepsToCook isEqualToString:@""]) {
        [resultString appendString:recipe.stepsToCook];
    }
    else {
        [resultString appendString:NSLocalizedString(@"Missing", nil)];
    }
    return resultString;
}

+(NSString *) composeEmailForRecipeBook:(RecipeBook *)recipeBook withHTML:(BOOL)withHTML {
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < recipeBook.arrayOfFoodTypes.count; i++) {
        withHTML ? [resultString appendString:@"<h2><hr>"] : nil;
        FoodType *type = (FoodType *) recipeBook.arrayOfFoodTypes[i];
        [resultString appendString:type.name];
        withHTML ? [resultString appendString:@"</h2>"] : nil;
        for (int j = 0; j < type.arrayOfRecipes.count; j++) {
            withHTML ? [resultString appendString:@"<hr>"] : nil;
            Recipe *recipe = (Recipe *) type.arrayOfRecipes[j];
            [resultString appendString:[Utilities composeEmailForRecipe:recipe withHTML:withHTML]];
            
        }
    }
    return resultString;
}

+(UIColor *) colorForCategory:(INGR_COLOR)catColor {
    switch (catColor) {
        case mainCategory:
            return [UIColor colorWithRed:0.9333 green:0.9961 blue:0.7765 alpha:1.0];
        break;
        case secondaryCategory:
            return [UIColor colorWithRed:0.9725 green:0.9490 blue:0.9020 alpha:1.0];
        default:
            return [UIColor colorWithRed:0.9333 green:0.9961 blue:0.7765 alpha:1.0];
    }
}

+(NSString *) shortDescriptionFromRecipe:(Recipe *)recipe {
    return nil;
}

@end
