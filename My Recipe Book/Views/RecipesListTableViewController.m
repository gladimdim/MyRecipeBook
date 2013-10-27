//
//  RecipesListTableViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "RecipesListTableViewController.h"
#import "Recipe.h"
#import "RecipeViewController.h"
@interface RecipesListTableViewController ()

@end

@implementation RecipesListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.foodType.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.foodType.arrayOfRecipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellRecipe";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Recipe *recipe = [self.foodType.arrayOfRecipes objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = recipe.name;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRecipe" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipe"]) {
        Recipe *recipe = (Recipe *) [self.foodType.arrayOfRecipes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        RecipeViewController *recipeVC = (RecipeViewController *) segue.destinationViewController;
        recipeVC.recipe = recipe;
        recipeVC.docFoodTypes = self.docFoodTypes;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.foodType.arrayOfRecipes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void) dataModelChanged {
    [self.docFoodTypes saveToURL:self.docFoodTypes.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Saved file.");
        }
        else {
            NSLog(@"File was not saved.");
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - Table edit
-(void) addButtonPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recipe name", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertView delegate methods
-(void) alertViewCancel:(UIAlertView *)alertView {
    [self.tableView endEditing:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *recipeName = [alertView textFieldAtIndex:0].text;
        if (recipeName) {
            [self setEditing:NO animated:YES];
            [self.foodType addRecipeWithName:recipeName];
            [self dataModelChanged];
        }
    }
}



@end
