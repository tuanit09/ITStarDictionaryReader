//
//  ITDictionary.m
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITDictionary.h"
#import "ITWordEntry.h"
#import "ITZipBlockEntry.h"
#import "ITWordSectionEntry.h"
#import "ITConstants.h"
#import "NSString+Value.h"
#import "ITDictionaryEngine.h"
#import "NSString+ZipFileName.h"
#import "NSData+ZIP.h"

#define kInfoWordSectionCount       50
#define kBlockNumber                5
#define kInfoFileExtension          kZipInfoFileExtension
#define kIndexFileExtension         kZipIndexFileExtension
#define kDataFileExtension          kZipDataBlockFileExtension
#define kBlockEntriesFileExtension  kZipBlockEntryFileExtension
#define kSynFileExtension           kZipSynFileExtension
#define kNewLine                    @"\n"

@interface ITDictionary()
{
    NSMutableArray      *_wordEntries;
    NSMutableArray      *_wordSectionEntries;
}

@end

@implementation ITDictionary
@synthesize wordEntries             =       _wordEntries;
@synthesize wordSectionEntries      =       _wordSectionEntries;

- (id)init
{
    // invalid function called. cannot use this to init
    return nil;
}

- (id) initWithDictionaryFolder:(NSURL *)folderURL;
{
    NSURL *infoFileURL = nil;
    NSURL *indexFileURL = nil;
    NSURL *dataFileURL = nil;
    NSURL *blockEntriesFileURL;
    NSURL * synFileURL = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:folderURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    if ([files count] < 4) {
        return nil;
    }
    for (NSURL *fileURL in files) {
        NSString *fileExtension = [[fileURL pathComponents] lastObject];
        if ([fileExtension hasSuffix:kInfoFileExtension]) {
            infoFileURL = fileURL;
        }
        else if ([fileExtension hasSuffix:kIndexFileExtension])
        {
            indexFileURL = fileURL;
        }
        else if ([fileExtension hasSuffix:kDataFileExtension])
        {
            dataFileURL = fileURL;
        }
        else if ([fileExtension hasSuffix:kBlockEntriesFileExtension])
        {
            blockEntriesFileURL = fileURL;
        }
        else if ([fileExtension hasSuffix:kSynFileExtension])
        {
            synFileURL = fileURL;
        }
    }
    return [self initWithInfoFile:infoFileURL indexFile:indexFileURL dataFile:dataFileURL blockEntriesFile:(NSURL *)blockEntriesFileURL synFile:synFileURL];
}

- (id) initWithInfoFile:(NSURL *)infoFileURL indexFile:(NSURL *)indexFileURL dataFile:(NSURL *)dataFileURL blockEntriesFile:(NSURL *)blockEntriesFileURL synFile:(NSURL *)synFileURL
{
    if (infoFileURL && indexFileURL && dataFileURL && blockEntriesFileURL) {
        if (self = [super init]) {
            _infoFileURL = infoFileURL;
            _indexFileURL = indexFileURL;
            _dataFileURL = dataFileURL;
            _blockEntriesFileURL = blockEntriesFileURL;
            _synFileURL = synFileURL;
        }
        return self;
    }
    return nil;
}

- (void)loadDictionaryForTarget:(id<ITDictionaryDelegate>)delegate
{
    [delegate willLoadDictionary:self];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadInfoFile];
        [self loadIndexFile];
        [self loadBlockEntries];
        [self loadSynFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate didLoadDictionary:self];
        });
    });
}

#pragma -mark private methods
/**
 load data for file at specified path
 @param filePath file to be read.
 @return lines of read data
 */
- (NSData *)dataForFile:(NSURL *)fileURL
{
    return [NSData dataWithContentsOfURL:fileURL];
}

/**
 Load info file
 */
#define kInfoVersionKey                     @"version="
#define kInfoBookNameKey                    @"bookname="
#define kInfoWordCountKey                   @"wordcount="
#define kInfoSynWordCountKey                @"synwordcount="
#define kInfoIdxFileSizeKey                 @"idxfilesize="
#define kInfoIdxOffsetBitsKey               @"idxoffsetbits="
#define kInfoAuthorKey                      @"author="
#define kInfoEmailKey                       @"email="
#define kInfoWebsiteKey                     @"website="
#define kInfoDescriptionKey                 @"description="
#define kInfoDateKey                        @"date="
#define kInfoSameTypeSequenceKey            @"sametypesequence="
#define kInfoLineEndKey                     @"\n"

- (void)loadInfoFile
{
    NSData *data = [[self dataForFile:self.infoFileURL] uncompressedData];
    NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    _version = [infoString substringBetweenBeinKey:kInfoVersionKey endKey:kInfoLineEndKey];
    _bookName = [infoString substringBetweenBeinKey:kInfoBookNameKey endKey:kInfoLineEndKey];
    _wordCount = [[infoString substringBetweenBeinKey:kInfoWordCountKey endKey:kInfoLineEndKey] unsignedIntegerValue];
    _synWordCount = [[infoString substringBetweenBeinKey:kInfoSynWordCountKey endKey:kInfoLineEndKey] unsignedIntegerValue];
    _idxFileSize = [[infoString substringBetweenBeinKey:kInfoIdxFileSizeKey endKey:kInfoLineEndKey] unsignedIntegerValue];
    _idxOffsetBits = [[infoString substringBetweenBeinKey:kInfoIdxOffsetBitsKey endKey:kInfoLineEndKey] unsignedIntegerValue];
    _author = [infoString substringBetweenBeinKey:kInfoAuthorKey endKey:kInfoLineEndKey];
    _email = [infoString substringBetweenBeinKey:kInfoEmailKey endKey:kInfoLineEndKey];
    _website = [infoString substringBetweenBeinKey:kInfoWebsiteKey endKey:kInfoLineEndKey];
    _description = [infoString substringBetweenBeinKey:kInfoDescriptionKey endKey:kInfoLineEndKey];
#warning incompleted
    //    _date   = [infoString substringBetweenBeinKey:kInfoDateKey endKey:kInfoLineEndKey];
    _sameTypeSequence = [infoString substringBetweenBeinKey:kInfoSameTypeSequenceKey endKey:kInfoLineEndKey];
    
}

- (void)getInt32:(NSUInteger *)pValue fromBytes:(Byte *)pBytes
{
//    uint32_t rawVal = *(uint32_t *)pBytes;
//    *pValue = (rawVal >> 24) | ((rawVal & 0x00FF0000) >> 16) | ((rawVal & 0x0000FF00) << 8) | ((rawVal & 0x000000FF) << 24);
    *pValue = *(uint32_t *)pBytes;
}
- (Byte)getIndex:(NSUInteger *)pIndex length:(NSUInteger *)pLenght fromBytes:(Byte *)pBytes
{
    // get index (offset) => an 32 bits number
    [self getInt32:pIndex fromBytes:pBytes];
    // get length => an 32bits number
    [self getInt32:pLenght fromBytes:pBytes + 4];
    return 8;
}

- (void)loadIndexFile
{
    // info file was not successfully loaded
    if (self.wordCount == 0) {
        return;
    }
    _letterAValue = !0; // maximum value
    _wordEntries = [[NSMutableArray alloc] initWithCapacity:self.wordCount];    // init array of entries
    _wordSectionEntries = [[NSMutableArray alloc] initWithCapacity:kInfoWordSectionCount];

    NSData *data = [[self dataForFile:self.indexFileURL] uncompressedData];    // load index file
    Byte *bytes = (Byte *)data.bytes;
    Byte *pBeginByte;
    Byte *pEndByte = bytes;
    NSUInteger wordCount = self.wordCount;
    NSUInteger sum = 0;

    /* in-while variables */
    NSString *strWord;
    NSUInteger meaningIndex;
    NSUInteger meaningLength;
    ITWordEntry *entry;
    ITWordSectionEntry *lastSectionEntry;
    ITWordSectionEntry *nextSectionEntry;
    unichar currentFirstLetter;
    NSString *uperCaseWord;
    while (wordCount) {
        /* begin the word */
        pBeginByte = pEndByte;

        /* find the end of the word '\0' */
        while(*(pEndByte += bytesMapUTF8[*pEndByte]));

        /* get the word out of bytes */
        strWord = [[NSString alloc] initWithBytes:pBeginByte length:pEndByte - pBeginByte encoding:NSUTF8StringEncoding];
        /* get index and length */
        pEndByte += [self getIndex:&meaningIndex length:&meaningLength fromBytes:++pEndByte];

        /* add word to entries */
        entry = [[ITWordEntry alloc] initWithWord:strWord offset:meaningIndex length:meaningLength];
        [_wordEntries addObject:entry];

        /* add new section for the word (if needed) */
        nextSectionEntry = nil;
        if ((lastSectionEntry = [_wordSectionEntries lastObject])) {
            uperCaseWord = [entry.word uppercaseString];
            if (![uperCaseWord hasPrefix:lastSectionEntry.firstLetter]) {
                lastSectionEntry.wordCount = [_wordEntries count] - lastSectionEntry.firstWordIndex - 1;
                nextSectionEntry = [[ITWordSectionEntry alloc] initWithFirstLetter:[[entry.word substringToIndex:1] uppercaseString] firstWordIndex:[_wordEntries count] - 1 wordCount:0];
                sum += lastSectionEntry.wordCount;

                currentFirstLetter = [lastSectionEntry.firstLetter characterAtIndex:0];
                if (currentFirstLetter >= 'A' && currentFirstLetter < _letterAValue) {
                    _letterAValue = currentFirstLetter;
                    _sectionAIndex = [_wordSectionEntries count];
                }
            }
        }
        else
        {
            nextSectionEntry = [[ITWordSectionEntry alloc] initWithFirstLetter:[[entry.word substringToIndex:1] uppercaseString] firstWordIndex:0 wordCount:0];
        }
        if (nextSectionEntry) {
            [_wordSectionEntries addObject:nextSectionEntry];
        }
        wordCount--;
    }
    lastSectionEntry = [_wordSectionEntries lastObject];
    if (lastSectionEntry) {
        lastSectionEntry.wordCount = [_wordEntries count] - lastSectionEntry.firstWordIndex;
        sum += lastSectionEntry.wordCount;
    }
}

- (void)loadBlockEntries
{
    NSData *data = [[self dataForFile:self.blockEntriesFileURL] uncompressedData];
    if ([data length] % [ITZipBlockEntry size]) {
        return;
    }
    Byte *beginByte = (Byte *)data.bytes;
    Byte *endByte = beginByte + data.length;
    NSMutableArray *entries = [[NSMutableArray alloc] initWithCapacity:kBlockNumber];
    while (beginByte < endByte) {
        ITZipBlockEntry *entry = [[ITZipBlockEntry alloc] initWithBytes:beginByte];
        beginByte += [ITZipBlockEntry size];
        [entries addObject:entry];
    }
    _blockEntries = entries;
}

/**
 Load syn file
 */
- (void)loadSynFile
{

}

@end
