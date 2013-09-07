//
//  Ingridient.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/20/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "Ingridient.h"

@implementation Ingridient

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.nameIngridient forKey:@"nameIngridient"];
    [aCoder encodeObject:self.amount forKey:@"amount"];
    [aCoder encodeObject:self.unitOfMeasure forKey:@"unitOfMeasure"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.nameIngridient = [aDecoder decodeObjectForKey:@"nameIngridient"];
        self.amount = [aDecoder decodeObjectForKey:@"amount"];
        self.unitOfMeasure = [aDecoder decodeObjectForKey:@"unitOfMeasure"];
    }
    return self;
}
@end
