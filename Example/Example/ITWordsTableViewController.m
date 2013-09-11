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
#import "NSString+ZipFileName.h"

#define kShowMeaning    @"showMeaning"

@interface ITWordsTableViewController ()<ITDictionaryDelegate, ITDictionaryEngineDelegate, UISearchBarDelegate>

@property (strong, nonatomic) ITDictionary *dictionary;
@property (strong, nonatomic) NSArray *entries;

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
//    NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:@"dict.ifo" withExtension:kZipFileExtension];
//    NSURL *idxFileURL = [[NSBundle mainBundle] URLForResource:@"dict.idx" withExtension:kZipFileExtension];
//    NSURL *dataFileURL = [[NSBundle mainBundle] URLForResource:@"dict.blockData" withExtension:kZipFileExtension];
//    NSURL *blockEntriesFileURL = [[NSBundle mainBundle] URLForResource:@"dict.blockEntries" withExtension:kZipFileExtension];
//    NSURL *synFileURL   = nil;
//    self.dictionary = [[ITDictionary alloc] initWithInfoFile:infoFileURL indexFile:idxFileURL dataFile:dataFileURL blockEntriesFile:blockEntriesFileURL synFile:synFileURL];
    NSURL *folderURL = [[NSBundle mainBundle] bundleURL];
    self.dictionary = [[ITDictionary alloc] initWithDictionaryFolder:folderURL];
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
        NSUInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];
        ITWordEntry *selectedEntry = [self.entries objectAtIndex:selectedRow];
        NSString *word = selectedEntry.word;
        NSString *meaning = [ITDictionaryEngine meaningForEntry:selectedEntry inDictionary:self.dictionary];
        ITMeaningViewController *meaningViewController = (ITMeaningViewController *)segue.destinationViewController;

        [meaningViewController setWord:word meaning:meaning];

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
    static NSString *CellIdentifier = @"CellIdentifier";
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
