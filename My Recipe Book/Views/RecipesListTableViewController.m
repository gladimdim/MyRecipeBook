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
#import "Backuper.h"
#import "ImportWebViewController.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentStateChanged:) name:UIDocumentStateChangedNotification object:self.docFoodTypes];
    [self.tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) documentStateChanged:(NSNotification *) notification {
    //if our foodType was not deleted after iCloud update - reread foodType from the same index
    //if there is not such element id - pop view to previous.
    if (self.indexOfFoodType < [self.docFoodTypes.recipeBook.arrayOfFoodTypes count] ) {
        self.foodType = (FoodType *) (self.docFoodTypes.recipeBook.arrayOfFoodTypes)[self.indexOfFoodType];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (self.docFoodTypes.documentState == UIDocumentStateInConflict) {
        [self.docFoodTypes resolve];
    }
    [self.tableView reloadData];
}


-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
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
    Recipe *recipe = (self.foodType.arrayOfRecipes)[indexPath.row];
    // Configure the cell...
    cell.textLabel.text = recipe.name;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRecipe" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipe"]) {
        Recipe *recipe = (Recipe *) (self.foodType.arrayOfRecipes)[[self.tableView indexPathForSelectedRow].row];
        RecipeViewController *recipeVC = (RecipeViewController *) segue.destinationViewController;
        recipeVC.recipe = recipe;
        recipeVC.docFoodTypes = self.docFoodTypes;
    }
    else if ([segue.identifier isEqualToString:@"showImportWebView"]) {
        ImportWebViewController *vc = (ImportWebViewController *) segue.destinationViewController;
        vc.foodType = self.foodType;
        vc.docFoodTypes = self.docFoodTypes;
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

-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Recipe *draggedRecipe = (Recipe *) self.foodType.arrayOfRecipes[sourceIndexPath.row];
    [self.foodType.arrayOfRecipes removeObject:draggedRecipe];
    [self.foodType.arrayOfRecipes insertObject:draggedRecipe atIndex:destinationIndexPath.row];
    [self dataModelChanged];
}

-(void) dataModelChanged {
    NSUInteger index = [self.docFoodTypes.recipeBook.arrayOfFoodTypes indexOfObject:self.foodType];
    self.docFoodTypes.recipeBook.arrayOfFoodTypes[index] = self.foodType;
    [self.docFoodTypes updateChangeCount:UIDocumentChangeDone];
    [Backuper backUpFileToLocalDrive:self.docFoodTypes];
    [self.tableView reloadData];
}

#pragma mark - Add button with actionsheet/alertview delegate
-(void) addButtonPressed {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Create recipe", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Manually add recipe", nil), NSLocalizedString(@"Import from popular sites", nil), nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self setEditing:NO];
        [self performSegueWithIdentifier:@"showImportWebView" sender:self];
    }
    else if (buttonIndex == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recipe name", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
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
