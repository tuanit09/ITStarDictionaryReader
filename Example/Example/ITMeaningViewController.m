//
//  ITMeaningViewController.m
//  Example
//
//  Created by Tuan Anh Nguyen on 9/5/13.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITMeaningViewController.h"

@interface ITMeaningViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ITMeaningViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma -mark Accessors

-(void)setFullMeaning:(NSString *)fullMeaning
{
    _fullMeaning = fullMeaning;
    _textView.text = fullMeaning;
}

@end
