//
//  FoodNetworkParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 2/16/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "FoodNetworkParser.h"
#import "Ingridient.h"
#import "Utilities.h"

@implementation FoodNetworkParser

+(FoodNetworkParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    FoodNetworkParser *parser = [[FoodNetworkParser alloc] init];
    parser.sRecipePath = [urlRecipe absoluteString];
    parser.dHTML = [NSData dataWithContentsOfURL:urlRecipe];
    parser.doc = [[TFHpple alloc] initWithHTMLData:parser.dHTML];
    return parser;
}

-(NSString *) getTitle {
    NSString *title = nil;
    NSArray *aTitle = [self.doc searchWithXPathQuery:@"//h1[@itemprop='name']"];
    if (aTitle.count > 0) {
        TFHppleElement *element = aTitle[0];
        title = [element text];
        return title;
    }
    else {
        return nil;
    }
}

-(NSString *) getPrepTime {
    NSArray *ar = [self.doc searchWithXPathQuery:@"//dd[@class='total']"];
    if (ar.count > 0) {
        TFHppleElement *el = (TFHppleElement *) ar[0];
        return el.text;
    }
    else {
        return nil;
    }
}

-(NSArray *) getIngredients {
    NSArray *aIngredients = [self.doc searchWithXPathQuery:@"//li[@itemprop='ingredients']"];
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

-(NSNumber *) getPortions {
    NSNumber *returnNumber = nil;
    NSArray *ar = [self.doc searchWithXPathQuery:@"//dd[@itemprop='recipeYield']"];
    if (ar.count > 0) {
        TFHppleElement *el = (TFHppleElement *) ar[0];
        NSString *str = el.text;
        NSArray *subStr = [str componentsSeparatedByString:@" "];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        if (subStr.count > 0) {
            NSString *sSub = subStr[0];
            returnNumber = [formatter numberFromString:sSub];
        }
        else {
          
            returnNumber = [formatter numberFromString:str];
        }
    }
    return returnNumber;
}

-(Recipe *) recipe {
    Recipe *recipe = [Recipe recipeWithName:[self getTitle]  stepsToCook:@""];
    recipe.arrayOfIngridients = [[NSMutableArray alloc] initWithArray:[self getIngredients]];
    recipe.name = [self getTitle];
    recipe.stepsToCook = [self getStepsToCook];
    recipe.duration = [self getPrepTime];
    recipe.portions = [self getPortions];
    return recipe;
}

@end
