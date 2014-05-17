//
//  FoodTypes.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodType : NSObject <NSCoding>
@property NSString *name;
@property NSMutableArray *arrayOfRecipes;
-(void) addRecipeWithName:(NSString *) name;
@end
