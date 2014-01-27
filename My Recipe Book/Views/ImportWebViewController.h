//
//  ImportWebViewController.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/26/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodType.h"
#import "FoodTypesDocument.h"

@interface ImportWebViewController : UIViewController
@property FoodType *foodType;
@property FoodTypesDocument *docFoodTypes;
@end
