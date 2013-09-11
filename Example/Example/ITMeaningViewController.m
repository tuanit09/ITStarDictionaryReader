//
//  ITMeaningViewController.m
//  Example
//
//  Created by Tuan Anh Nguyen on 9/5/13.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITMeaningViewController.h"

@interface ITMeaningViewController ()
{
    NSString *_word;
    NSString *_meaning;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.wordLabel setText:_word];
    [self.textView setText:_meaning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [self setWordLabel:nil];
    [super viewDidUnload];
}

-(void)setWord:(NSString *)word meaning:(NSString *)meaning
{
    _word = word;
    _meaning = meaning;
}

@end
