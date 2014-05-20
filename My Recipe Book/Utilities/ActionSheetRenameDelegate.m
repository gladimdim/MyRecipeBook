//
//  ActionSheetRenameDelegate.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 5/20/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "ActionSheetRenameDelegate.h"
#import "Backuper.h"

@implementation ActionSheetRenameDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    FoodType *type = self.docFoodTypes.recipeBook.arrayOfFoodTypes[buttonIndex - 1];
    
    for (FoodType *sourceType in self.docFoodTypes.recipeBook.arrayOfFoodTypes) {
        if ([sourceType.arrayOfRecipes containsObject:self.recipe]) {
            [sourceType.arrayOfRecipes removeObject:self.recipe];
            [type.arrayOfRecipes addObject:self.recipe];
            [self.docFoodTypes updateChangeCount:UIDocumentChangeDone];
            [Backuper backUpFileToLocalDrive:self.docFoodTypes];
            break;
        }
    }
}
@end
