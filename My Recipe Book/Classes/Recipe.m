//
//  Recipe.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/20/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayOfIngridients forKey:@"arrayOfIngridients"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.stepsToCook forKey:@"stepsToCook"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.arrayOfIngridients = [aDecoder decodeObjectForKey:@"arrayOfIngridients"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.description = [aDecoder decodeObjectForKey:@"description"];
        self.stepsToCook = [aDecoder decodeObjectForKey:@"stepsToCook"];
    }
    return self;
}
@end
