//
//  FoodTypes.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodType.h"

@interface FoodType()
@end

@implementation FoodType

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayOfSubTypes forKey:@"arrayOfSubTypes"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.arrayOfSubTypes = [aDecoder decodeObjectForKey:@"arrayOfSubTypes"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

-(void) addSubType:(NSString *)subTypeName {
    FoodSubType *foodSubType = [[FoodSubType alloc] init];
    foodSubType.name = subTypeName;
    foodSubType.arrayOfRecipes = [NSMutableArray array];
    [self.arrayOfSubTypes addObject:foodSubType];
}

@end
