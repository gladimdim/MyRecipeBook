//
//  MeatTypesTableViewController.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/14/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTypesDocument.h"
#import "FoodType.h"

@interface FoodSubTypesListTableViewController : UITableViewController
@property FoodType *foodType;
@property FoodTypesDocument *docFoodTypes;
@end
