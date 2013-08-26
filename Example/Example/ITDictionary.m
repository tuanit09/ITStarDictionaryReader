//
//  ITDictionary.m
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITDictionary.h"

#define kInfoFilePathSuffix     @".ifo"
#define kIndexFilePathSuffix    @".idx"
#define kDataFilePathSuffix     @".dict"
#define kSynFilePathSuffix      @".syn"
#define kNewLine                @"\n"

@interface ITDictionary()

@property (strong, nonatomic) NSArray *entries; // override the property.

@end

@implementation ITDictionary

- (id)init
{
    // invalid function called. cannot use this to init
    return nil;
}

- (id)initWithDictionaryFolder:(NSString *)dictionaryFolderPath
{
    NSString *infoPath = nil;
    NSString *indexPath = nil;
    NSString *dataPath = nil;
    NSString * synPath = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dictionaryFolderPath error:nil];
    if ([files count] < 4) {
        return nil;
    }
    for (NSString *file in files) {
        if ([file hasSuffix:kInfoFilePathSuffix]) {
            infoPath = file;
        }
        else if ([file hasSuffix:kIndexFilePathSuffix])
        {
            indexPath = file;
        }
        else if ([file hasSuffix:kDataFilePathSuffix])
        {
            dataPath = file;
        }
        else if ([file hasSuffix:kSynFilePathSuffix])
        {
            synPath = file;
        }
    }
    return [self initWithInfoFile:infoPath indexFile:indexPath dataFile:dataPath synFile:synPath];
}

- (id)initWithInfoFile:(NSString *)infoPath indexFile:(NSString *)indexPath dataFile:(NSString *)dataPath synFile:(NSString *)synPath
{
    if (!infoPath || !indexPath || !dataPath || !synPath) {
        // invalid parameter
        return nil;
    }

    if (self = [super init]) {
        _infoFilePath = infoPath;
        _indexFilePath = indexPath;
        _dataFilePath = dataPath;
        _synFilePath = synPath;
    }
    return self;
}

- (void)loadDictionary
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadInfoFile];
        [self loadIndexFile];
        [self loadSynFile];
    });
}

#pragma -mark private methods
/**
 load data for file at specified path
 @param filePath file to be read.
 @return lines of read data
 */
- (NSArray *)dataForFile:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [string componentsSeparatedByString:@"\n"];
}
/**
 Load info file
 */
- (void)loadInfoFile
{

}

/**
 Load index file
 */
- (void)loadIndexFile
{

}

/**
 Load syn file
 */
- (void)loadSynFile
{

}

@end
