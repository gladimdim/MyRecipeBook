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
#import "FoodTypesDocument.h"

@interface FoodListTableViewController () <UIAlertViewDelegate>
@property FoodTypes *foodTypes;
@property FoodTypesDocument *docFoodTypes;
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
    if (self.foodTypes == nil) {
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
            self.foodTypes = self.docFoodTypes.foodTypes;
            [self.tableView reloadData];
        }
        else {
            [self initNewFileWithDummyData];
        }
    }];
}

-(void) initNewFileWithDummyData {
    self.foodTypes = [[FoodTypes alloc] init];
    self.foodTypes.arrayFoodCategories = [self.foodTypes generateFoodTypes];
    self.docFoodTypes.foodTypes = self.foodTypes;
    [self dataModelChanged];
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
    return self.foodTypes.arrayFoodCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellFoodType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = (NSDictionary *) [self.foodTypes.arrayFoodCategories objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *) [dict allKeys][0];
    // Configure the cell...
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showFoodTypes" sender:self];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    if (indexPath.row == self.foodTypes.arrayFoodCategories.count - 1) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"inserted");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Provide name", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.foodTypes.arrayFoodCategories removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self dataModelChanged];
    }
}

#pragma mark - UIAlertView delegate methods
-(void) alertViewCancel:(UIAlertView *)alertView {
    [self.tableView endEditing:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *typeName = [alertView textFieldAtIndex:0].text;
        if (typeName) {
            [self.foodTypes addCategory:typeName];
            [self dataModelChanged];
        }
    }
}

-(void) dataModelChanged {
    self.docFoodTypes.foodTypes = self.foodTypes;
    [self.docFoodTypes saveToURL:self.docFoodTypes.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Doc saved");
        }
        else {
            NSLog(@"DOc was not saved");
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSMutableDictionary *dict = (NSMutableDictionary *) [self.foodTypes.arrayFoodCategories objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    FoodTypesTableViewController *foodVC = (FoodTypesTableViewController *) [segue destinationViewController];
    foodVC.dictFood = dict;
    foodVC.docFoodTypes = self.docFoodTypes;
}

@end
