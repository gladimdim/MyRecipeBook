//
//  ImportWebViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/26/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "ImportWebViewController.h"
#import "RecipeHTMLParser.h"
#import "Recipe.h"
#import "RecipeBook.h"
#import "Backuper.h"

@interface ImportWebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ImportWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadHTMLString:@"<html>\
     <title>Test\
     </title>\
     <body>\
     <p><a href='http://www.vkusnyblog.ru'>Вкусный блог</a>\
     <p><a href='http://www.allrecipes.com'>allrecipes.com</a>\
     </body>\
     </html>" baseURL:nil];
}

- (IBAction)btnImportPressed:(id)sender {
    RecipeHTMLParser *parser = [RecipeHTMLParser parserWithRecipePath:[self.webView.request.URL absoluteString]];
    NSLog(@"Title; %@", [parser getTitle]);
    NSLog(@"Ingredients: %@", [parser getIngredients]);
    [self.foodType.arrayOfRecipes addObject:[parser recipe]];
    [self dataModelChanged];
}

-(void) dataModelChanged {
    NSUInteger index = [self.docFoodTypes.recipeBook.arrayOfFoodTypes indexOfObject:self.foodType];
    [self.docFoodTypes.recipeBook.arrayOfFoodTypes replaceObjectAtIndex:index withObject:self.foodType];
    [self.docFoodTypes updateChangeCount:UIDocumentChangeDone];
    NSLog(@"kuku: %i", [self.docFoodTypes.recipeBook.arrayOfFoodTypes indexOfObject:self.foodType]);
    [Backuper backUpFileToLocalDrive:self.docFoodTypes];
}

@end
