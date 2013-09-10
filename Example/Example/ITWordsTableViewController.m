//
//  ITWordsTableViewController.m
//  Example
//
//  Created by Tuan Anh Nguyen on 9/5/13.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITWordsTableViewController.h"
#import "ITWordEntry.h"
#import "ITDictionary.h"
#import "ITDictionaryEngine.h"
#import "ITMeaningViewController.h"

#define kShowMeaning    @"showMeaning"

@interface ITWordsTableViewController ()<ITDictionaryDelegate, ITDictionaryEngineDelegate, UISearchBarDelegate>

@property (strong, nonatomic) ITDictionary *dictionary;
@property (strong, nonatomic) NSArray *entries;
@property (strong, nonatomic) ITWordEntry *selectedEntry;

@end

@implementation ITWordsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *infoFile = [[NSBundle mainBundle] pathForResource:@"en_vi" ofType:@"ifo"];
    NSString *indexFile = [[NSBundle mainBundle] pathForResource:@"en_vi" ofType:@"idx"];
    NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"en_vi.dict" ofType:@"dz"];
    self.dictionary = [[ITDictionary alloc] initWithInfoFile:infoFile indexFile:indexFile dataFile:dataFile synFile:nil];
    [self.dictionary loadDictionaryForTarget:self];
}

#pragma -mark private methods

- (void)updateTableViewWithData:(NSArray *)data
{
    @synchronized(self.entries)
    {
        self.entries = data;
        [self.tableView reloadData];
    }
}

#pragma -mark Segue Delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowMeaning]) {
        ITMeaningViewController *meaningViewController = (ITMeaningViewController *)segue.destinationViewController;
        meaningViewController.fullMeaning = [ITDictionaryEngine meaningForEntry:self.selectedEntry inDictionary:self.dictionary];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ITWordEntry *entry = (ITWordEntry *)[self.entries objectAtIndex:[indexPath row]];
    cell.textLabel.text = entry.word;
    return cell;
}

#pragma mark - Table view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedEntry = [self.entries objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:kShowMeaning sender:self];
}

#pragma -mark Search Bar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [ITDictionaryEngine searchForWord:searchText inDictionary:self.dictionary forTarget:self];
}

#pragma -mark Dictionary Delegate

-(void)willLoadDictionary:(ITDictionary *)dic
{

}

-(void)didLoadDictionary:(ITDictionary *)dic
{
    [self updateTableViewWithData:dic.wordEntries];
}

#pragma -mark Dictionary Engine Delegate

- (void)dictionaryEngineWillSearchInDictionary:(ITDictionary *)dictionary
{
    
}

- (void)dictionaryEngineDidSearchInDictionary:(ITDictionary *)dictionary withResult:(NSArray *)results
{
    [self updateTableViewWithData:results];
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
