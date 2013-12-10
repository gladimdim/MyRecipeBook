//
//  RecipesListTableViewController.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodType.h"
#import "FoodTypesDocument.h"

@interface RecipesListTableViewController : UITableViewController
@property FoodType *foodType;
@property FoodTypesDocument *docFoodTypes;
@property NSUInteger indexOfFoodType;
@end
