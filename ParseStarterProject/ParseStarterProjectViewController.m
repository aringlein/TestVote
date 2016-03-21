/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ParseStarterProjectViewController.h"

#import <Parse/Parse.h>

@interface ParseStarterProjectViewController()

//outlets for automatically turning off switches
@property (weak, nonatomic) IBOutlet UISwitch *s0;
@property (weak, nonatomic) IBOutlet UISwitch *s1;
@property (weak, nonatomic) IBOutlet UISwitch *s2;
@property (weak, nonatomic) IBOutlet UISwitch *s3;
//outlets for displaying vote counts
@property (weak, nonatomic) IBOutlet UILabel *o0;
@property (weak, nonatomic) IBOutlet UILabel *o1;
@property (weak, nonatomic) IBOutlet UILabel *o2;
@property (weak, nonatomic) IBOutlet UILabel *o3;
//outlet for changing the title text
@property (weak, nonatomic) IBOutlet UILabel *TitleShow;
@end

@implementation ParseStarterProjectViewController

//objectID for the parse object which stores the votes
NSString *countID = @"2gakJVJTWP";
//array to store which voteCount needs to be incremented
int switchVals[4] = {0, 0, 0, 0};
//array to store a vote to be subtracted if the vote changes
int storeVote[4] = {0, 0, 0, 0};
//boolean to keep track of whether the user has changed his/her vote since voting
bool reVote = NO;

#pragma mark -
#pragma mark UIViewController
//events which trigger when the user flips each of the switches
- (IBAction)switch0:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    //reset the switchVals
    for (int i = 0; i < 4; i ++) {
        switchVals[i] = 0;
    }
    //reset all of the other switches
    [_s1 setOn:NO animated:YES];
    [_s2 setOn:NO animated:YES];
    [_s3 setOn:NO animated:YES];
    //set the switchval based on the state of the given switch
    if ([mySwitch isOn]) {
        switchVals[0] = 1;
    } else {
        switchVals[0] = 0;
    }
    //note that the user's vote has changed
    reVote = YES;
}

- (IBAction)switch1:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    
    for (int i = 0; i < 4; i ++) {
        switchVals[i] = 0;
    }
    
    [_s0 setOn:NO animated:YES];
    [_s2 setOn:NO animated:YES];
    [_s3 setOn:NO animated:YES];
    
    if ([mySwitch isOn]) {
        switchVals[1] = 1;
    } else {
        switchVals[1] = 0;
    }
    reVote = YES;
}

- (IBAction)switch2:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    
    for (int i = 0; i < 4; i ++) {
        switchVals[i] = 0;
    }
    
    [_s0 setOn:NO animated:YES];
    [_s1 setOn:NO animated:YES];
    [_s3 setOn:NO animated:YES];

    if ([mySwitch isOn]) {
        switchVals[2] = 1;
    } else {
        switchVals[2] = 0;
    }
    reVote = YES;
}

- (IBAction)switch3:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    
    for (int i = 0; i < 4; i ++) {
        switchVals[i] = 0;
    }
    
    [_s0 setOn:NO animated:YES];
    [_s1 setOn:NO animated:YES];
    [_s2 setOn:NO animated:YES];
    
    if ([mySwitch isOn]) {
        switchVals[3] = 1;
    } else {
        switchVals[3] = 0;
    }
    reVote = YES;
}

//event which triggers when the user presses the submit vote button
- (IBAction)submit:(id)sender {
    //if the user has changed the vote
    if (reVote) {
        //perform a search of the parse server for the VoteCount Object
        PFQuery *query = [PFQuery queryWithClassName:@"VoteCount"];
        [query getObjectInBackgroundWithId:countID
            block:^(PFObject *VoteCount, NSError *error) {
                                         
            //set the vote counts to: the old count - the saved vote + the new vote
            VoteCount[@"switch0"] = @(switchVals[0]+ [VoteCount[@"switch0"] intValue] - storeVote[0]);
            VoteCount[@"switch1"] = @(switchVals[1]+ [VoteCount[@"switch1"] intValue] - storeVote[1]);
            VoteCount[@"switch2"] = @(switchVals[2]+ [VoteCount[@"switch2"] intValue] - storeVote[2]);
            VoteCount[@"switch3"] = @(switchVals[3]+ [VoteCount[@"switch3"] intValue] - storeVote[3]);
                                         
            //set the displayed vote totals to be the correct values
            [_o0 setText:[NSString stringWithFormat:@"%i", [VoteCount[@"switch0"] intValue]]];
            [_o1 setText:[NSString stringWithFormat:@"%i", [VoteCount[@"switch1"] intValue]]];
            [_o2 setText:[NSString stringWithFormat:@"%i", [VoteCount[@"switch2"] intValue]]];
            [_o3 setText:[NSString stringWithFormat:@"%i", [VoteCount[@"switch3"] intValue]]];
                                         
            //set the alpha values of the vote totals to display them
            [_o0 setAlpha:1];
            [_o1 setAlpha:1];
            [_o2 setAlpha:1];
            [_o3 setAlpha:1];
                                         
            //save the voteCount object
            [VoteCount saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                NSLog(@"There was no sending error");
            } else {
                // There was a problem, check error.description
                NSLog(@"There was a sending error, %@", error.description);
            }
        }];
                                         
        //store the current values in switchVals
        //NSLog(@"%@", VoteCount);
        for (int i = 0; i < 4; i++) {
            storeVote[i] = switchVals[i];
        }
        //change the title
        [_TitleShow setText:@"Total Votes:"];
        //don't resubmit votes if the vote doesn't change
        reVote = NO;
        
        }];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
