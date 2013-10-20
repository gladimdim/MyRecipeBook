//
//  FoodTypesTableViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/11/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodTypesListTableViewController.h"
#import "RecipesListTableViewController.h"
#import "FoodTypesDocument.h"
#import "RecipeBook.h"

@interface FoodTypesListTableViewController () <UIAlertViewDelegate>
@property RecipeBook *recipeBook;
@property FoodTypesDocument *docFoodTypes;
@end

@implementation FoodTypesListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.recipeBook == nil) {
        [self initFoodTypes];
    }
}

-(void) initFoodTypes {
    NSURL *baseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *docURL = [NSURL URLWithString:[[baseURL absoluteString]  stringByAppendingString:@"foodTypes"]];
    self.docFoodTypes = [[FoodTypesDocument alloc] initWithFileURL:docURL];
    [self.docFoodTypes openWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"opened");
            self.recipeBook = self.docFoodTypes.recipeBook;
            if (self.recipeBook == nil) {
                [self initNewFileWithDummyData];
            }
            [self.tableView reloadData];
        }
        else {
            [self initNewFileWithDummyData];
        }
    }];
}

-(void) initNewFileWithDummyData {
    self.recipeBook = [[RecipeBook alloc] init];
    self.recipeBook.arrayOfFoodTypes = [NSMutableArray array];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipeBook.arrayOfFoodTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellFoodType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    FoodType *foodType = (FoodType *) [self.recipeBook.arrayOfFoodTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = foodType.name;
    // Configure the cell...
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRecipesList" sender:self];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.recipeBook.arrayOfFoodTypes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self dataModelChanged];
    }
}

-(void) dataModelChanged {
    self.docFoodTypes.recipeBook = self.recipeBook;
    [self.docFoodTypes saveToURL:self.docFoodTypes.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Doc saved");
        }
        else {
            NSLog(@"Doc was not saved");
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FoodType *foodType = (FoodType *) [self.recipeBook.arrayOfFoodTypes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    RecipesListTableViewController *recipeListVC = (RecipesListTableViewController *) [segue destinationViewController];
    recipeListVC.foodType = foodType;
    recipeListVC.docFoodTypes = self.docFoodTypes;
}

#pragma mark - Table edit
-(void) addButtonPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Provide name", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertView delegate methods
-(void) alertViewCancel:(UIAlertView *)alertView {
    [self.tableView endEditing:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *typeName = [alertView textFieldAtIndex:0].text;
        if (typeName) {
            [self setEditing:NO animated:YES];
            [self.recipeBook addFoodTypeWithName:typeName];
            [self dataModelChanged];
        }
    }
}



@end
