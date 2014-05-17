//
//  Recipe.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/20/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject <NSCoding>
@property NSMutableArray *arrayOfIngridients;
@property NSString *name;
@property NSString *description;
@property NSString *stepsToCook;
@property NSString *duration;
@property NSNumber *portions;
@property UIImage *image;
+(Recipe *) recipeWithName:(NSString *) name stepsToCook:(NSString *) stepsToCook;
-(NSString *) ingredientsArrayToString;
@end

