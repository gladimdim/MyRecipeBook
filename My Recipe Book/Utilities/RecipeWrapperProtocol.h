//
//  RecipeWrapperProtocol.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/25/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "TFHpple.h"

@protocol RecipeWrapperProtocol <NSObject>
@optional
-(NSArray *) getIngredients;
-(NSString *) getTitle;
-(NSString *) getStepsToCook;
-(NSString *) getPrepTime;
-(NSNumber *) getPortions;
@end
