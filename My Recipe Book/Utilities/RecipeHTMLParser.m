//
//  RecipeHTMLParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/25/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeHTMLParser.h"
#import "Say7InfoParser.h"
#import "AllRecipesParser.h"
#import "SimplyrecipesParser.h"
#import "GoodCookParser.h"
#import "FoodNetworkParser.h"
#import "CarinaParser.h"

@implementation RecipeHTMLParser
+(RecipeHTMLParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    NSString *domainName = [urlRecipe host];
    if ([domainName isEqualToString:@"www.say7.info"]) {
        return [Say7InfoParser parserWithRecipePath:urlRecipe];
    }
    else if ([domainName isEqualToString:@"m.allrecipes.com"]) {
        return [AllRecipesParser parserWithRecipePath:urlRecipe];
    }
    else if ([domainName isEqualToString:@"www.simplyrecipes.com"]) {
        return [SimplyrecipesParser parserWithRecipePath:urlRecipe];
    }
    else if ([domainName isEqualToString:@"www.good-cook.ru"]) {
        return [GoodCookParser parserWithRecipePath:urlRecipe];
    }
    else if ([domainName isEqualToString:@"www.foodnetwork.com"]) {
        return [FoodNetworkParser parserWithRecipePath:urlRecipe];
    }
    else if ([domainName isEqualToString:@"www.carina-forum.com"]) {
        return [CarinaParser parserWithRecipePath:urlRecipe];
    }
    else {
        return nil;
    }
}

@end
