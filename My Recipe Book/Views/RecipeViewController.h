//
//  RecipeViewController.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/14/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import "Recipe.h"
#import "FoodTypesDocument.h"

@interface RecipeViewController : UIViewController <EKEventEditViewDelegate>
@property Recipe *recipe;
@property FoodTypesDocument *docFoodTypes;
@end
