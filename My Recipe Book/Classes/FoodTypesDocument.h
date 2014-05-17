//
//  FoodTypesDocument.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 9/6/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeBook.h"

@interface FoodTypesDocument : UIDocument
@property (strong) RecipeBook *recipeBook;
-(void) resolve;
@end
