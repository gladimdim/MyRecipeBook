//
//  FoodParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 2/9/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "SimplyrecipesParser.h"
#import "TFHpple.h"
#import "Ingridient.h"
#import "Utilities.h"

@implementation SimplyrecipesParser

+(SimplyrecipesParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    SimplyrecipesParser *parser = [[SimplyrecipesParser alloc] init];
    parser.sRecipePath = [urlRecipe absoluteString];
    parser.dHTML = [NSData dataWithContentsOfURL:urlRecipe];
    parser.doc = [[TFHpple alloc] initWithHTMLData:parser.dHTML];
    return parser;
}

-(NSString *) getTitle {
    NSString *title = nil;
    NSArray *aTitle = [self.doc searchWithXPathQuery:@"//h1[@class='entry-title fn']"];
    TFHppleElement *element = aTitle[0];
    title = [element text];
    return title;
}

-(NSArray *) getIngredients {
    NSArray *aIngredients = [self.doc searchWithXPathQuery:@"//div[@id='recipe-ingredients']/ul/li"];
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
    NSArray *arr = [self.doc searchWithXPathQuery:@"//div[@id='recipe-method']/p"];
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
    recipe.duration = [self getPrepTime];
    return recipe;
}

-(NSString *) getPrepTime {
    NSArray *aTime = [self.doc searchWithXPathQuery:@"//span[@class='cooktime']"];
    //there are different class names for the same div. If first failed search for next class
    if (aTime.count == 0) {
        aTime = [self.doc searchWithXPathQuery:@"//span[@class='preptime']"];
    }

    if (aTime.count > 0) {
        TFHppleElement *el = aTime[0];
        if (el.children.count > 0) {
            TFHppleElement *elCh = el.children[0];
            NSString *fullStr = elCh.content;
            //if time is in format "45 minutes" we need to take only 45
            NSArray *arr = [fullStr componentsSeparatedByString:@" "];
            if (arr.count > 0) {
                return arr[0];
            }
            else {
                return elCh.content;
            }
        }
        else {
            return  nil;
        }
    }
    else {
        return nil;
    }
}

@end
