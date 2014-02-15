//
//  Utilities.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 10/21/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeBook.h"
#import "Recipe.h"

@interface Utilities : NSObject
#define IOS7_VERSION  (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
+(NSString *) composeEmailForRecipe:(Recipe *) recipe withHTML:(BOOL) withHTML;
+(NSString *) composeEmailForRecipeBook:(RecipeBook *) recipeBook withHTML:(BOOL) withHTML;
typedef NS_ENUM(int, INGR_COLOR) {
    mainCategory = 0,
    secondaryCategory = 1
};
+(UIColor *) colorForCategory:(INGR_COLOR) catColor;
+(UIFont *) fontForIngredientCell;
@end
