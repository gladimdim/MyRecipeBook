//
//  MeatTypesTableViewController.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/14/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTypesDocument.h"

@interface FoodTypesTableViewController : UITableViewController
@property NSMutableDictionary *dictFood;
@property FoodTypesDocument *docFoodTypes;
@end
