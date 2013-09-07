//
//  FoodTypes.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodTypes : NSObject <NSCoding>
-(NSMutableArray *) generateFoodTypes;
-(void) addCategory:(NSString *) categoryName;
@property NSMutableArray *arrayFoodCategories;
@end
