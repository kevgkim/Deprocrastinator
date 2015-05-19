//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Kevin on 5/18/15.
//  Copyright (c) 2015 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addTaskTextField;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property NSMutableArray *toDoList;
@property NSIndexPath *indexToDelete;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [[NSMutableArray alloc] initWithObjects:@"Walk the dog", @"Do the dishes", @"Kick the cat", @"Give Max a high five", nil];
    self.taskTableView.allowsMultipleSelectionDuringEditing = NO;

}
- (IBAction)onUserSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint swipePoint = [sender locationInView:self.taskTableView];
        NSIndexPath *swipedIndexPath = [self.taskTableView indexPathForRowAtPoint:swipePoint];
        UITableViewCell *swipedCell = [self.taskTableView cellForRowAtIndexPath:swipedIndexPath];
        if (swipedCell.textLabel.textColor == [UIColor blackColor]) {
            swipedCell.textLabel.textColor = [UIColor redColor];
        } else if (swipedCell.textLabel.textColor == [UIColor redColor]) {
            swipedCell.textLabel.textColor = [UIColor yellowColor];
        } else if (swipedCell.textLabel.textColor == [UIColor yellowColor]) {
            swipedCell.textLabel.textColor = [UIColor greenColor];
        } else {
            swipedCell.textLabel.textColor = [UIColor blackColor];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSString *task = [self.toDoList objectAtIndex:sourceIndexPath.row];
    [self.toDoList removeObject:task];
    [self.toDoList insertObject:task atIndex:destinationIndexPath.row];
    [self.taskTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoList count];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"you are about to delete an item");
        UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"Do you want to slack off" message:@"you should probably do this!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        deleteAlertView.delegate = self;
        [deleteAlertView show];
        self.indexToDelete = indexPath;
        [self.taskTableView reloadData];
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alert view dismiss was called");
    if (buttonIndex == 1) {
        [self.toDoList removeObjectAtIndex:self.indexToDelete.row];
        [self.taskTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexToDelete] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.toDoList objectAtIndex:indexPath.row];

    return cell;
}
- (IBAction)onEditButtonPressed:(UIButton *)sender {
    [sender setTitle:@"Done" forState:UIControlStateNormal];
    [self.taskTableView setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
}

- (IBAction)onAddButtonPressed:(id)sender {
    if ([self.addTaskTextField.text  isEqual: @""]) {
        return;
    }
    NSString *taskToAddString = self.addTaskTextField.text;
    [self.toDoList addObject:taskToAddString];
    [self.taskTableView reloadData];
    [self.addTaskTextField resignFirstResponder];
    self.addTaskTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
