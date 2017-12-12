//
//  SearchViewController.m
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation SearchViewController

- (IBAction)searchButtonPressed:(UIButton *)sender {
    [self.delegate fetchData:self.searchTextField.text];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
