//
//  RecipeViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/14/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "IngridientsTableView.h"
#import "Ingridient.h"
#import "Utilities.h"
@import MessageUI;

@interface RecipeViewController ()
@property EKEventStore *eventStore;
@property EKCalendar *calendar;
@property EKEvent *event;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableViewIngridients;
@property (strong, nonatomic) IngridientsTableView *tableViewIngridientsDelegate;
@property (strong, nonatomic) IBOutlet UITextView *textViewStepsToCook;
@property (strong, nonatomic) IBOutlet UIButton *btnAddSReminder;
@property (strong, nonatomic) UITextField *txtFieldIngrName;
@property (strong, nonatomic) UITextField *txtFieldAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldDuration;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldPortions;
- (IBAction)btnSharedPressed:(id)sender;
@property MFMailComposeViewController *mail;
@end

@implementation RecipeViewController

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
    self.eventStore = [[EKEventStore alloc] init];
    [self checkAccessToCalendars];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableViewIngridientsDelegate = [[IngridientsTableView alloc] init];
    self.tableViewIngridientsDelegate.recipe = self.recipe;
    self.tableViewIngridients.delegate = self.tableViewIngridientsDelegate;
    self.tableViewIngridients.dataSource = self.tableViewIngridientsDelegate;
    __weak RecipeViewController *self_weak = self;
    self.tableViewIngridientsDelegate.addIngridient = ^(Ingridient *ingr) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self_weak.recipe.arrayOfIngridients.count inSection:0];
        [self_weak.recipe.arrayOfIngridients insertObject:ingr atIndex:self_weak.recipe.arrayOfIngridients.count];
        [self_weak.tableViewIngridients insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self_weak.tableViewIngridients scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self_weak dataModelChanged];
    };
    self.tableViewIngridientsDelegate.removeIngridient = ^(NSIndexPath *indexPath) {
        if (indexPath.row > 0 && indexPath.row < self_weak.recipe.arrayOfIngridients.count) {
            [self_weak.recipe.arrayOfIngridients removeObjectAtIndex:indexPath.row];
            [self_weak.tableViewIngridients deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self_weak dataModelChanged];
        }

    };

    self.txtFieldDuration.text = self.recipe.duration;
    self.txtFieldPortions.text = [self.recipe.portions stringValue];
    self.textViewStepsToCook.text = self.recipe.stepsToCook;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self.tableViewIngridients reloadData];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = self.recipe.name;
}

-(void) viewDidLayoutSubviews {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight= screen.size.height;
    self.scrollView.contentSize = CGSizeMake(640, screenHeight == 568 ? 354 : 266);
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableViewIngridients setEditing:editing animated:YES];
    [self.tableViewIngridientsDelegate setEditing:editing animated:animated];
    self.textViewStepsToCook.editable = editing;
    self.txtFieldPortions.enabled = editing;
    self.txtFieldDuration.enabled = editing;
    
    if (editing) {
        self.txtFieldDuration.borderStyle = UITextBorderStyleLine;
        self.txtFieldPortions.borderStyle = UITextBorderStyleLine;
        //add dummy ingr object to display new row in table view.
        Ingridient *ingr = [[Ingridient alloc] init];
        [self.recipe.arrayOfIngridients insertObject:ingr atIndex:0];
        [self.tableViewIngridients reloadData];
    }
    else {
        [self.recipe.arrayOfIngridients removeObjectAtIndex:0];
        [self.tableViewIngridients reloadData];
        self.txtFieldDuration.borderStyle = UITextBorderStyleNone;
        self.txtFieldPortions.borderStyle = UITextBorderStyleNone;
        
        [self.txtFieldIngrName resignFirstResponder];
        [self.txtFieldAmount resignFirstResponder];
        //write down steps to cook when Done is pressed
        self.recipe.stepsToCook = self.textViewStepsToCook.text;
        self.recipe.duration = self.txtFieldDuration.text;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        self.recipe.portions = self.txtFieldPortions.text ? [formatter numberFromString:self.txtFieldPortions.text] : [NSNumber numberWithInt:0];
        [self dataModelChanged];
    }
}

-(void) requestAccess {
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"Granted: %@", granted ? @"YES" : @"NO");
        if (granted) {
            [self prepareEvent];
        }
    }];
}

-(void) checkAccessToCalendars {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityMaskEvent];
    switch (status) {
        case EKAuthorizationStatusAuthorized: {
            [self prepareEvent];
        }
            break;
        case EKAuthorizationStatusNotDetermined: {
            [self requestAccess];
        }
            break;
        case EKAuthorizationStatusDenied: {
            
        }
            break;
        case EKAuthorizationStatusRestricted: {
            
        }
    }
}

-(void) prepareEvent {
    self.event = [EKEvent eventWithEventStore:self.eventStore];
    self.event.title = [NSString stringWithFormat:NSLocalizedString(@"Prepare %@", nil), self.recipe.name];
    NSMutableString *notes = [NSMutableString string];
    for (int i = 0; i < self.recipe.arrayOfIngridients.count; i++) {
        Ingridient *ingr = [self.recipe.arrayOfIngridients objectAtIndex:i];
        [notes appendString:[NSString stringWithFormat:@"%@ %@\n", ingr.nameIngridient, ingr.amount]];
    }
    self.event.notes = notes;
}

- (IBAction)recipeReminderAddPressed:(id)sender {
    EKEventEditViewController *viewController = [[EKEventEditViewController alloc] init];
    [self prepareEvent];
    viewController.event = self.event;
    viewController.eventStore = self.eventStore;
    [self presentViewController:viewController animated:YES completion:nil];
    viewController.editViewDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(EKCalendar *) eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    return self.eventStore.defaultCalendarForNewEvents;
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
    //[self.tableViewIngridients reloadData];
    self.textViewStepsToCook.text = self.recipe.stepsToCook;
}

-(void) addButtonPressed {
    if (self.txtFieldIngrName.text && ![self.txtFieldIngrName.text isEqualToString:@""]) {
        [self.recipe addIngridientWithName:self.txtFieldIngrName.text amount:self.txtFieldAmount.text];
        self.txtFieldIngrName.text = @"";
        self.txtFieldAmount.text = @"";
        [self.txtFieldIngrName becomeFirstResponder];
        [self dataModelChanged];
    }
}

- (IBAction)btnSharedPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        self.mail = [[MFMailComposeViewController alloc] init];
        [self.mail setMailComposeDelegate:self];
        [self.mail setSubject:[NSString stringWithFormat:NSLocalizedString(@"Recipe for %@", nil), self.recipe.name]];
       // [self.mail setMessageBody:[Utilities composeEmailForRecipe:self.recipe withHTML:YES] isHTML:YES];
        [self.mail setMessageBody:[Utilities composeEmailForRecipeBook:self.docFoodTypes.recipeBook withHTML:YES] isHTML:YES];
        [self.navigationController presentViewController:self.mail animated:YES completion:nil];
    }
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self.mail dismissViewControllerAnimated:YES completion:nil];
}

@end
