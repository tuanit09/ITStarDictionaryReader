//
//  ITDictionaryEngine.m
//  Example
//
//  Created by Nguyen Anh Tuan on 30/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITDictionaryEngine.h"
#import "ITDictionary.h"
#import "ITWordSectionEntry.h"
#import "ITWordEntry.h"
#import "ITZipBlockEntry.h"
#import "NSData+ZIP.h"

@implementation ITDictionaryEngine


+ (void)searchForWord:(NSString *)word inDictionary:(ITDictionary *)dictionary forTarget:(id<ITDictionaryEngineDelegate>)delegate
{
    [delegate dictionaryEngineWillSearchInDictionary:dictionary];
    __block NSString *__word = word;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *results = dictionary.wordEntries;
            if ([__word length]) {
                NSMutableArray *tempDict = nil;
                __word = [__word uppercaseString];
                unichar searchedLetterVal = [__word characterAtIndex:0];
                NSUInteger firstIndex = 0;
                NSUInteger lastIndex = [dictionary.wordSectionEntries count] - 1;
                NSUInteger middleIndex;
                ITWordSectionEntry *middleSectionEntry;
                unichar middleLetterVal;
                do {
                    middleIndex = (firstIndex + lastIndex) / 2;
                    middleSectionEntry = [dictionary.wordSectionEntries objectAtIndex:middleIndex];
                    middleLetterVal = [middleSectionEntry.firstLetter characterAtIndex:0];
                    if (middleLetterVal > searchedLetterVal) {
                        lastIndex = middleIndex;
                    }
                    else if (middleLetterVal < searchedLetterVal)
                    {
                        firstIndex = middleIndex;
                    }
                    else
                    {
                        break;
                    }
                } while (lastIndex > firstIndex);
                if (searchedLetterVal == middleLetterVal) {
                    tempDict = [[NSMutableArray alloc] initWithCapacity:middleSectionEntry.wordCount];
                    NSUInteger entryIndex = middleSectionEntry.firstWordIndex;
                    ITWordEntry *wordEntry = [dictionary.wordEntries objectAtIndex:entryIndex];
                    NSString *entryWord = [wordEntry.word uppercaseString];
                    while ([__word compare:entryWord] == NSOrderedDescending) {
                        //  NSLog(@"compared word = %@", entryWord);
                        entryIndex++;
                        wordEntry = [dictionary.wordEntries objectAtIndex:entryIndex];
                        entryWord = [wordEntry.word uppercaseString];
                        if (entryIndex >= [dictionary.wordEntries count]) {
                            break;
                        }
                    }
                    NSUInteger maxIndex = middleSectionEntry.wordCount + middleSectionEntry.firstWordIndex;
                    while ([entryWord hasPrefix:__word]) {
                        [tempDict addObject:wordEntry];
                        entryIndex ++;

                        if (entryIndex >= maxIndex) {
                            break;
                        }
                        
                        wordEntry = [dictionary.wordEntries objectAtIndex:entryIndex];
                        entryWord = [wordEntry.word uppercaseString];
                    }
                }
                results = tempDict;
            }
            [delegate dictionaryEngineDidSearchInDictionary:dictionary withResult:results];
        });
    });
}

+(ITZipBlockEntry *)blockEntryForWordEntry:(ITWordEntry *)wordEntry inDictionary:(ITDictionary *)dictionary
{
    if ([dictionary.blockEntries count]) {
        for (NSInteger i = [dictionary.blockEntries count] - 1; i >= 0; i--) {
            ITZipBlockEntry *blockEntry = [dictionary.blockEntries objectAtIndex: i];
            if (blockEntry.dataOffset <= wordEntry.offset) {
                return blockEntry;
            }
        }
    }
    return nil;
}

+ (NSString *)meaningForEntry:(ITWordEntry *)entry inDictionary:(ITDictionary *)dictionary
{
    ITZipBlockEntry *blockEntry = [self blockEntryForWordEntry:entry inDictionary:dictionary];
    NSData *meaningData = nil;
    if (blockEntry) {
        NSFileHandle *file = [NSFileHandle fileHandleForReadingFromURL:dictionary.dataFileURL error:nil];
        [file seekToFileOffset:blockEntry.zipOffset];
        NSData *blockData = [[file readDataOfLength:blockEntry.zipSize] uncompressedData];
        [file closeFile];
        meaningData = [NSData dataWithBytes:blockData.bytes + entry.offset - blockEntry.dataOffset length:entry.length];
    }
    return [[NSString alloc] initWithData:meaningData encoding:NSUTF8StringEncoding];
}

+ (NSArray *)synonymsForEntry:(ITWordEntry *)entry inDictionary:(ITDictionary *)dictionary
{
    return nil;
}

@end
