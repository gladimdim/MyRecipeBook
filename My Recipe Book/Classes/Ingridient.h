//
//  Ingridient.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/20/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingridient : NSObject <NSCoding>
@property NSString *nameIngridient;
@property NSString *amount;
@property UIColor *color;
@end
