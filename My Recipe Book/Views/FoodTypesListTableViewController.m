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
#import "CloudManager.h"
#import "Backuper.h"

@interface FoodTypesListTableViewController () <UIAlertViewDelegate>
@property RecipeBook *recipeBook;
@property FoodTypesDocument *docFoodTypes;
@property BOOL iCloudSettingChanged;
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
    /*if (self.recipeBook == nil) {
        [self initFoodTypes];
    }*/
    self.recipeBook = self.docFoodTypes.recipeBook;
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudSettingChanged:) name:NSUbiquityIdentityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentStateChanged:) name:UIDocumentStateChangedNotification object:self.docFoodTypes];
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

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDocumentStateChangedNotification object:self.docFoodTypes];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initFile];
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

-(void) iCloudSettingChanged:(NSNotification *) notification {
    /*if (![self.navigationController.topViewController isKindOfClass:[FoodTypesListTableViewController class]]) {
        [self.navigationController pushViewController:self animated:YES];
    }*/
    self.iCloudSettingChanged = YES;
    [self initFile];
}

-(void) documentStateChanged:(NSNotification *) notification {
    self.recipeBook = self.docFoodTypes.recipeBook;
    if (self.docFoodTypes.documentState == UIDocumentStateInConflict) {
        [self.docFoodTypes resolve];
    }
    [self.tableView reloadData];
}

-(void) initFile {
    [[CloudManager sharedManager] initCloudAccessWithCompletion:^(BOOL available) {
        //check if local file exists when iCloud is on and iCloud is file is absend. If yes - overwrite iCloud file with local copy
        NSURL *localURL = [[CloudManager sharedManager] localDocumentURL];
        NSURL *iCloudURL = [CloudManager sharedManager].iCloudURL;
        NSError *error;
        //[[NSFileManager defaultManager] removeItemAtURL:iCloudURL error:&error];
        if (available) {
            BOOL iCloudFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[iCloudURL path] isDirectory:NO];
            BOOL localFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[localURL path] isDirectory:NO];
            if (localFileExists && !iCloudFileExists) {
                NSError *error;
                // [[NSFileManager defaultManager] copyItemAtURL:localURL toURL:iCloudURL error:&error];
                [[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:localURL destinationURL:iCloudURL error:&error];
            }
        }
        
        NSURL *docURL = available ? [CloudManager sharedManager].iCloudURL : [[CloudManager sharedManager] localDocumentURL];
        self.docFoodTypes = [[FoodTypesDocument alloc] initWithFileURL:docURL];
        if (self.recipeBook == nil || self.iCloudSettingChanged) {
            [self initFoodTypes];
            self.iCloudSettingChanged = NO;
        }
        else {
            [self.tableView reloadData];
        }
    }];
}

-(void) initFoodTypes {
    //    self.recipeBook = self.docFoodTypes.recipeBook;
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
    [self.recipeBook generateDummyStructure];
    
    [self dataModelChanged];
    [self.tableView reloadData];
    //[self setEditing:YES animated:YES];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", foodType.arrayOfRecipes.count];
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
    [self.docFoodTypes updateChangeCount:UIDocumentChangeDone];
    [Backuper backUpFileToLocalDrive:self.docFoodTypes];
   /* [self.docFoodTypes saveToURL:self.docFoodTypes.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Doc saved");
        }
        else {
            NSLog(@"Doc was not saved");
        }
    }];*/
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FoodType *foodType = (FoodType *) [self.recipeBook.arrayOfFoodTypes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    RecipesListTableViewController *recipeListVC = (RecipesListTableViewController *) [segue destinationViewController];
    recipeListVC.indexOfFoodType = (NSUInteger) self.tableView.indexPathForSelectedRow.row;
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
