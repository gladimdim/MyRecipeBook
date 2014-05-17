//
//  VkusnyblogParser.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/25/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeHTMLParser.h"
#import "RecipeWrapperProtocol.h"

@interface VkusnyblogParser : RecipeHTMLParser <RecipeWrapperProtocol>
+(VkusnyblogParser *) parserWithRecipePath:(NSURL *) urlRecipe;
@end
