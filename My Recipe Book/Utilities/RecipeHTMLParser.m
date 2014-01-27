//
//  RecipeHTMLParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/25/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeHTMLParser.h"
#import "VkusnyblogParser.h"

@implementation RecipeHTMLParser
+(RecipeHTMLParser *) parserWithRecipePath:(NSString *)sRecipePath {
    return [VkusnyblogParser parserWithRecipePath:sRecipePath];
}

@end
