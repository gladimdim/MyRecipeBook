//
//  FoodTypes.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodSubType.h"

@interface FoodType : NSObject <NSCoding>
@property NSMutableArray *arrayOfSubTypes;
@property NSString *name;
-(void) addSubType:(NSString *)subTypeName;
@end
