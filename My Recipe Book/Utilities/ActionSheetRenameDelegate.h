//
//  ActionSheetRenameDelegate.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 5/20/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "Recipe.h"
#import "FoodTypesDocument.h"

@interface ActionSheetRenameDelegate : NSObject <UIActionSheetDelegate>
@property Recipe *recipe;
@property FoodTypesDocument *docFoodTypes;
@end
