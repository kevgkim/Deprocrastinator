//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Kevin on 5/18/15.
//  Copyright (c) 2015 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addTaskTextField;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property NSMutableArray *toDoList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [[NSMutableArray alloc] initWithObjects:@"Walk the dog", @"Do the dishes", @"Kick the cat", @"Give Max a high five", nil];
    self.taskTableView.allowsMultipleSelectionDuringEditing = NO;

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
        [self.toDoList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.taskTableView reloadData];

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
    NSString *taskToAddString = self.addTaskTextField.text;
    [self.toDoList addObject:taskToAddString];
    [self.toDoList addObject:@"run to the store"];
    [self.taskTableView reloadData];
    [self.addTaskTextField resignFirstResponder];
    self.addTaskTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
