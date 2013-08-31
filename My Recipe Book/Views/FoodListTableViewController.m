//
//  FoodTypesTableViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/11/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FoodListTableViewController.h"
#import "FoodTypes.h"
#import "FoodTypesTableViewController.h"

@interface FoodListTableViewController ()
@property FoodTypes *foodTypes;
@property NSArray *arrayOfFoodTypes;
@end

@implementation FoodListTableViewController

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
    self.foodTypes = [[FoodTypes alloc] init];
    self.arrayOfFoodTypes = [self.foodTypes generateFoodTypes];
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
    return self.arrayOfFoodTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellFoodType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = (NSDictionary *) [self.arrayOfFoodTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *) [dict allKeys][0];
    // Configure the cell...
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showFoodTypes" sender:self];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrayOfFoodTypes.count - 1) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleInsert;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
    else {
        
    }
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSDictionary *dict = (NSDictionary *) [self.arrayOfFoodTypes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    FoodTypesTableViewController *foodVC = (FoodTypesTableViewController *) [segue destinationViewController];
    foodVC.dictFood = dict;
}

@end
