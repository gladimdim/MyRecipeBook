//
//  MeatTypesTableViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/14/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodTypesTableViewController.h"
#import "RecipesListTableViewController.h"

@interface FoodTypesTableViewController ()
- (IBAction)btnEditPressed:(id)sender;
@property NSArray *arrayOfExactTypes;
@end

@implementation FoodTypesTableViewController

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
    self.arrayOfExactTypes = [self.dictFood objectForKey:[self.dictFood allKeys][0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.arrayOfExactTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellExactFood";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [self.arrayOfExactTypes objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [dict allKeys][0];
    NSArray *arrayOfRecipes = (NSArray *) [dict objectForKey:[dict allKeys][0]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", arrayOfRecipes.count];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRecipesList" sender:self];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RecipesListTableViewController *recipeListVC = (RecipesListTableViewController *) [segue destinationViewController];
    NSDictionary *dict = (NSDictionary *) [self.arrayOfExactTypes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    recipeListVC.arrayOfRecipes = [dict objectForKey:[dict allKeys][0]];
}

@end
