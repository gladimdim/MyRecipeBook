//
//  FoodSubTypes.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 9/21/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FoodSubType : NSObject
@property NSMutableArray *arrayOfRecipes;
@property NSString *name;
-(void) addRecipeWithName:(NSString *) name;
@end
