//
//  Say7InfoParser.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 2/8/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeHTMLParser.h"

@interface Say7InfoParser : RecipeHTMLParser
+(Say7InfoParser *) parserWithRecipePath:(NSURL *) urlRecipe;
@end
