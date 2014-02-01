//
//  RecipeHTMLParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/25/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeHTMLParser.h"
#import "VkusnyblogParser.h"
#import "AllRecipesParser.h"

@implementation RecipeHTMLParser
+(RecipeHTMLParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    NSString *domainName = [urlRecipe host];
    if ([domainName isEqualToString:@"www.vkusnyblog.ru"]) {
        return [VkusnyblogParser parserWithRecipePath:urlRecipe];
    }
    else if ([domainName isEqualToString:@"m.allrecipes.com"]) {
        return [AllRecipesParser parserWithRecipePath:urlRecipe];
    }
    else {
        return nil;
    }
}

@end
