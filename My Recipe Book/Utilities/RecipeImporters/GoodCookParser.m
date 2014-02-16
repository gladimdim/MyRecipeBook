//
//  GoodCookParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 2/16/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "GoodCookParser.h"
#import "Ingridient.h"
#import "Utilities.h"

@implementation GoodCookParser

+(GoodCookParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    GoodCookParser *parser = [[GoodCookParser alloc] init];
    parser.sRecipePath = [urlRecipe absoluteString];
    parser.dHTML = [NSData dataWithContentsOfURL:urlRecipe];
    parser.doc = [[TFHpple alloc] initWithHTMLData:parser.dHTML];
    return parser;
}

-(NSString *) getTitle {
    NSString *title = nil;
    NSArray *aTitle = [self.doc searchWithXPathQuery:@"//h1[@itemprop='name']"];
    TFHppleElement *element = aTitle[0];
    title = [element text];
    return title;
}

-(NSArray *) getIngredients {
    NSArray *aIngredients = [self.doc searchWithXPathQuery:@"//span[@itemprop='ingredients']"];
    if (aIngredients.count > 0) {
        NSMutableArray *ingrArray = [NSMutableArray array];
        for (TFHppleElement *el in aIngredients) {
            if (el.children.count > 0) {
                TFHppleElement *ch = el.children[0];
                Ingridient *ingr = [[Ingridient alloc] init];
                ingr.nameIngridient = [ch content];
                ingr.color = [Utilities colorForCategory:mainCategory];
                [ingrArray addObject:ingr];
            }
        }
        return ingrArray;
    }
    else {
        return nil;
    }
}

-(NSString *) getStepsToCook {
    NSString *sReturn = @"";
    NSArray *arr = [self.doc searchWithXPathQuery:@"//div[@itemprop='recipeInstructions']/p"];
    if (arr.count > 0) {
        for (TFHppleElement *el in arr) {
            for (TFHppleElement *chEl in el.children) {
                if (chEl.isTextNode) {
                    sReturn = [NSString stringWithFormat:@"%@\n%@", sReturn, chEl.content];
                }
            }
        }
        return sReturn;
    }
    else {
        return nil;
    }
}

-(Recipe *) recipe {
    Recipe *recipe = [Recipe recipeWithName:[self getTitle]  stepsToCook:@""];
    recipe.arrayOfIngridients = [[NSMutableArray alloc] initWithArray:[self getIngredients]];
    recipe.name = [self getTitle];
    recipe.stepsToCook = [self getStepsToCook];
    return recipe;
}

@end
