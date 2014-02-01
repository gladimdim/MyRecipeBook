//
//  VkusnyblogParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/25/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "VkusnyblogParser.h"
#import "TFHpple.h"
#import "Ingridient.h"
#import "Recipe.h"
#import "Utilities.h"

@interface VkusnyblogParser()
@property NSData *dHTML;
@property NSString *sRecipePath;
@property TFHpple *doc;
@end


@implementation VkusnyblogParser

+(VkusnyblogParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    VkusnyblogParser *parser = [[VkusnyblogParser alloc] init];
    parser.sRecipePath = [urlRecipe absoluteString];
    parser.dHTML = [NSData dataWithContentsOfURL:urlRecipe];
    parser.doc = [[TFHpple alloc] initWithHTMLData:parser.dHTML];
    return parser;
}

-(NSString *) getTitle {
    NSString *title = nil;
    NSArray *aTitle = [self.doc searchWithXPathQuery:@"//h1[@class='fn']"];
    TFHppleElement *element = aTitle[0];
    title = [element text];
    return title;
}

-(NSArray *) getIngredients {
    NSArray *aIngredients = [self.doc searchWithXPathQuery:@"//span[@class='instructions']/p[2]"];
    if (aIngredients.count == 0) {
        aIngredients = [self.doc searchWithXPathQuery:@"//span[@class='summary']/p[4]"];
    }
    TFHppleElement *element = aIngredients[0];
    return [self parseIngredientsFromElement:element];
}

-(NSString *) getStepsToCook {
    return nil;
}

-(NSArray *) parseIngredientsFromElement:(TFHppleElement *) element {
    NSMutableArray *array = [NSMutableArray array];
    for (TFHppleElement *el in element.children) {
        if (el.isTextNode) {
            Ingridient *ingr = [[Ingridient alloc] init];
            ingr.nameIngridient = [el.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            ingr.color = [Utilities colorForCategory:mainCategory];
            [array addObject:ingr];
        }
    }
    return array.count > 0 ? array : nil;
}

-(Recipe *) recipe {
    Recipe *recipe = [Recipe recipeWithName:[self getTitle]  stepsToCook:@""];
    recipe.arrayOfIngridients = [[NSMutableArray alloc] initWithArray:[self getIngredients]];
    return recipe;
}
@end
