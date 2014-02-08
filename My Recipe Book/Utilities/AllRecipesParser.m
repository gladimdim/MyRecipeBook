//
//  AllRecipesParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/27/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "AllRecipesParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "Ingridient.h"
#import "Recipe.h"
#import "Utilities.h"

@interface AllRecipesParser()
@end

@implementation AllRecipesParser
+(AllRecipesParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    AllRecipesParser *parser = [[AllRecipesParser alloc] init];
    parser.sRecipePath = [urlRecipe absoluteString];
    parser.dHTML = [NSData dataWithContentsOfURL:urlRecipe];
    parser.doc = [[TFHpple alloc] initWithHTMLData:parser.dHTML];
    return parser;
}

-(NSString *) getTitle {
    NSString *title = nil;
    NSArray *aTitle = [self.doc searchWithXPathQuery:@"//div[@class='recipe-details-right clearfix']/h1"];
    if (aTitle.count > 0) {
        TFHppleElement *element = aTitle[0];
        title = [element text];
        return title;
    }
    else {
        return nil;
    }
}

-(NSArray *) getIngredients {
    NSArray *aIngredients =  [self.doc searchWithXPathQuery:@"//span[@class='recipe-ingred_txt added']"];
    if (aIngredients.count > 0) {
        NSMutableArray *ingrArray = [NSMutableArray array];
        [ingrArray addObjectsFromArray:[self parseIngredientsFromElement:aIngredients]];
        aIngredients = [self.doc searchWithXPathQuery:@"//span[@class='recipe-ingred_txt']"];
        [ingrArray addObjectsFromArray:[self parseIngredientsFromElement:aIngredients]];
        return ingrArray;
    }
    else {
        return nil;
    }

}

-(NSArray *) parseIngredientsFromElement:(NSArray *) arrayOfElements {
    NSMutableArray *array = [NSMutableArray array];
    for (TFHppleElement *el in arrayOfElements) {
        if (el.children.count > 0) {
            TFHppleElement *children = (TFHppleElement *) el.children[0];
            if (children.isTextNode) {
                Ingridient *ingr = [[Ingridient alloc] init];
/******comment uncomment if you want ot parse ingredients with their amounts.
 With allrecipes it does not look good on screen:
 tablespoon butter 1. In origin it is 1 tablespoon butter.
 *****/
                /*NSString *sIngr = children.content;
                NSString *sFirst = [sIngr substringToIndex:1];
                if ([sFirst integerValue] != 0 || [sFirst isEqualToString:@"0"]) {
                    NSArray *ar = [sIngr componentsSeparatedByString:@" "];
                    if (ar.count > 0) {
                        ingr.amount = ar[0];
                        ingr.nameIngridient = [sIngr stringByReplacingOccurrencesOfString:ar[0] withString:@""];
                    }
                    else {
                        ingr.nameIngridient = [children.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    }
                }
                else {*/
                ingr.nameIngridient = [children.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                }
                ingr.color = [Utilities colorForCategory:mainCategory];
                [array addObject:ingr];
            }
        }
    }
    return array.count > 0 ? array : nil;
}

-(NSString *) getPrepTime {
    NSArray *arr = [self.doc searchWithXPathQuery:@"//span[@class='time'][3]"];
    NSString *sReturn;
    for (TFHppleElement *el in arr) {
        TFHppleElement *ch = (TFHppleElement *) el.children[0];
        sReturn = ch.content;
    }
    NSArray *arrUnits = [self.doc searchWithXPathQuery:@"//span[@class='time'][3]/span[1]"];
    NSString *timeUnits = nil;
    for (TFHppleElement *el in arrUnits) {
        TFHppleElement *ch = (TFHppleElement *) el.children[0];
        timeUnits = ch.content;
    }
    return [NSString stringWithFormat:@"%@%@", sReturn, timeUnits];
}

-(NSString *) getStepsToCook {
    NSString *sReturn = @"";
    NSArray *arr = [self.doc searchWithXPathQuery:@"//section[@class='sail'][2]/ol/li/span"];
    if (arr.count > 0) {
        for (TFHppleElement *el in arr) {
            if (el.children.count > 0) {
                TFHppleElement *ch = (TFHppleElement *) el.children[0];
                sReturn = [NSString stringWithFormat:@"%@\n%@", sReturn, ch.content];
            }
        }
        return sReturn;
    }
    else {
        return nil;
    }
}

-(NSNumber *) getPortions {
    NSNumber *nReturn = nil;;
    NSArray *arr = [self.doc searchWithXPathQuery:@"//input[@id='servings']"];
    if (arr.count > 0) {
        TFHppleElement *el = arr[0];
        NSDictionary *attr = el.attributes;
        NSString *portions = [attr objectForKey:@"data-original"];
        if (portions) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            nReturn = [formatter numberFromString:portions];
        }
        return nReturn;
    }
    else {
        return nil;
    }
}

-(Recipe *) recipe {
    Recipe *recipe = [Recipe recipeWithName:[self getTitle]  stepsToCook:@""];
    recipe.arrayOfIngridients = [[NSMutableArray alloc] initWithArray:[self getIngredients]];
    recipe.duration = [self getPrepTime];
    recipe.stepsToCook = [self getStepsToCook];
    recipe.portions = [self getPortions];
    return recipe;
}

@end
