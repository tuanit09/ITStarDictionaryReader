//
//  ITDictionary.m
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITDictionary.h"

#define kInfoFileExtension     @"ifo"
#define kIndexFileExtension    @"idx"
#define kDataFileExtension     @"dz"
#define kSynFileExtension      @"syn"
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
        if ([file hasSuffix:kInfoFileExtension]) {
            infoPath = file;
        }
        else if ([file hasSuffix:kIndexFileExtension])
        {
            indexPath = file;
        }
        else if ([file hasSuffix:kDataFileExtension])
        {
            dataPath = file;
        }
        else if ([file hasSuffix:kSynFileExtension])
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
- (NSData *)dataForFile:(NSString *)filePath
{
    return [NSData dataWithContentsOfFile:filePath];
}
/**
 Load info file
 */
- (void)loadInfoFile
{
    NSData *data = [self dataForFile:self.infoFilePath];
    NSLog(@"done %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
}

/**
 Load index file
 */
- (void)loadIndexFile
{
    NSData *data = [self dataForFile:self.indexFilePath];
    Byte *bytes = (Byte *)data.bytes;
    NSInteger beginDataIndex = 0;
    NSInteger endDataIndex;

    NSInteger wordCount = 0;
    while (beginDataIndex < [data length]) {
        endDataIndex = beginDataIndex;
        while (bytes[endDataIndex])
        {
            ++endDataIndex;
        }
        NSString *str = [[NSString alloc] initWithBytes:bytes + beginDataIndex length:endDataIndex - beginDataIndex encoding:NSUTF8StringEncoding];
        beginDataIndex = endDataIndex + 9;
        NSLog(@"word = %@", str);
    }
}

/**
 Load syn file
 */
- (void)loadSynFile
{

}

@end
