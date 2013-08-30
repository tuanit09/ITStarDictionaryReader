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

@implementation ITDictionaryEngine


+ (void)searchForWord:(NSString *)word inDictionary:(ITDictionary *)dictionary forTarget:(id<ITDictionaryDelegate>)delegate
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

                
                results = tempDict;
            }
            [delegate dictionaryEngineDidSearchInDictionary:dictionary withResult:results];
        });
    });
}

@end
