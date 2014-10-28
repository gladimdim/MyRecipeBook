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
#import "RecipeHTMLParser.h"

@interface FoodTypesListTableViewController () <UIAlertViewDelegate>
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

    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudSettingChanged:) name:NSUbiquityIdentityDidChangeNotification object:nil];
    if (self.docFoodTypes) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentStateChanged:) name:UIDocumentStateChangedNotification object:self.docFoodTypes];
    }
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

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.iCloudSettingChanged = YES;
    [self initFile];
}

-(void) documentStateChanged:(NSNotification *) notification {
    if (self.docFoodTypes.documentState == UIDocumentStateInConflict) {
        [self.docFoodTypes resolve];
            NSLog(@"Document updated stat changed with conflicts");
    }
    [self.tableView reloadData];
}

-(void) initFile {
    [[CloudManager sharedManager] initCloudAccessWithCompletion:^(BOOL available) {
        //check if local file exists when iCloud is on and iCloud is file is absend. If yes - overwrite iCloud file with local copy
        NSURL *localURL = [[CloudManager sharedManager] localDocumentURL];
        NSURL *iCloudURL = [CloudManager sharedManager].iCloudURL;

        if (available) {
            BOOL isDir = NO;
            BOOL iCloudFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[iCloudURL path] isDirectory:&isDir];
            BOOL localFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[localURL path] isDirectory:&isDir];
            if (localFileExists && !iCloudFileExists) {
                NSError *error;
                // [[NSFileManager defaultManager] copyItemAtURL:localURL toURL:iCloudURL error:&error];
                [[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:localURL destinationURL:iCloudURL error:&error];
            }
        }
        
        NSURL *docURL = available ? iCloudURL : localURL;
        self.docFoodTypes = [[FoodTypesDocument alloc] initWithFileURL:docURL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentStateChanged:) name:UIDocumentStateChangedNotification object:self.docFoodTypes];
        if (self.docFoodTypes.recipeBook == nil || self.iCloudSettingChanged) {
            [self initFoodTypes];
            self.iCloudSettingChanged = NO;
        }
        else {
            [self.tableView reloadData];
        }
    }];
}

-(void) initFoodTypes {
    [self.docFoodTypes openWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"opened");
            if (self.docFoodTypes.recipeBook == nil) {
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
    self.docFoodTypes.recipeBook = [[RecipeBook alloc] init];
    [self.docFoodTypes.recipeBook generateDummyStructure];
    
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
    return self.docFoodTypes.recipeBook.arrayOfFoodTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellFoodType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    FoodType *foodType = (FoodType *) (self.docFoodTypes.recipeBook.arrayOfFoodTypes)[indexPath.row];
    cell.textLabel.text = foodType.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)foodType.arrayOfRecipes.count];
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
        [self.docFoodTypes.recipeBook.arrayOfFoodTypes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self dataModelChanged];
    }
}

-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    FoodType *sourceFoodType = (FoodType *) self.docFoodTypes.recipeBook.arrayOfFoodTypes[sourceIndexPath.row];
    [self.docFoodTypes.recipeBook.arrayOfFoodTypes removeObjectAtIndex:sourceIndexPath.row];
    [self.docFoodTypes.recipeBook.arrayOfFoodTypes insertObject:sourceFoodType atIndex:destinationIndexPath.row];
    [self dataModelChanged];
}


-(void) dataModelChanged {
    [self.docFoodTypes updateChangeCount:UIDocumentChangeDone];
    [Backuper backUpFileToLocalDrive:self.docFoodTypes];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FoodType *foodType = (FoodType *) (self.docFoodTypes.recipeBook.arrayOfFoodTypes)[self.tableView.indexPathForSelectedRow.row];
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
            [self.docFoodTypes.recipeBook addFoodTypeWithName:typeName];
            [self dataModelChanged];
        }
    }
}

@end
