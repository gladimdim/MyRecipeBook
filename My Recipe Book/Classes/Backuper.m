//
//  Backuper.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 12/11/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "Backuper.h"
#import "CloudManager.h"
#import "FoodTypesDocument.h"
#import "Recipe.h"
#import "RecipeBook.h"
#import "FoodType.h"

@implementation Backuper
+(void) backUpFileToLocalDrive:(FoodTypesDocument *)fileToBackup {
    if ([CloudManager sharedManager].iCloudAvailable) {
        FoodTypesDocument *doc = [[FoodTypesDocument alloc] initWithFileURL:[[CloudManager sharedManager] localDocumentURL]];
       /* [doc openWithCompletionHandler:^(BOOL success) {
            if (success) {
                //check if food type exists in local copy. if yes - scan recipes and add if necessary
                for (FoodType *cloudFoodType in fileToBackup.recipeBook.arrayOfFoodTypes) {
                    FoodType *foundLocalType = [doc.recipeBook containsFoodTypeByName:cloudFoodType.name];
                    if (foundLocalType) {
                        for (Recipe *cloudRecipe in cloudFoodType.arrayOfRecipes) {
                            if (![doc.recipeBook findRecipeByName:cloudRecipe.name]) {
                                [foundLocalType.arrayOfRecipes addObject:cloudRecipe];
                            }
                        }
                    }
                    [doc.recipeBook.arrayOfFoodTypes addObject:cloudFoodType];
                }
            }
            else {*/
                doc.recipeBook = fileToBackup.recipeBook;
                [doc saveToURL:[[CloudManager sharedManager] localDocumentURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                    NSLog(@"Backup saved: %@", success ? @"YES" : @"NO");
                }];
/*
            }
        }];*/
    }
}
@end
