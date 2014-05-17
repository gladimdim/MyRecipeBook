//
//  AllRecipesParser.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/27/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeHTMLParser.h"

@interface AllRecipesParser : RecipeHTMLParser
+(AllRecipesParser *) parserWithRecipePath:(NSURL *) urlRecipe;
@end
