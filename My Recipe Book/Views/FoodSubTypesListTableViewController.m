//
//  MeatTypesTableViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/14/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodSubTypesListTableViewController.h"
#import "RecipesListTableViewController.h"

@interface FoodSubTypesListTableViewController ()
@property NSMutableArray *arrayOfSubTypes;
@end

@implementation FoodSubTypesListTableViewController

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
    self.title = [self.dictFood allKeys][0];
    self.arrayOfSubTypes = [self.dictFood objectForKey:[self.dictFood allKeys][0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.arrayOfSubTypes ? self.arrayOfSubTypes.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellExactFood";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [self.arrayOfSubTypes objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [dict allKeys][0];
    NSArray *arrayOfRecipes = (NSArray *) [dict objectForKey:[dict allKeys][0]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", arrayOfRecipes.count];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRecipesList" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.arrayOfSubTypes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
        [self dataModelChanged];
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
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RecipesListTableViewController *recipeListVC = (RecipesListTableViewController *) [segue destinationViewController];
    NSMutableDictionary *dict = (NSMutableDictionary *) [self.arrayOfSubTypes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    recipeListVC.arrayOfRecipes = (NSMutableArray *) [dict objectForKey:[dict allKeys][0]];
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
           // [self.foodTypes addCategory:typeName];
            [self dataModelChanged];
        }
    }
}



@end
