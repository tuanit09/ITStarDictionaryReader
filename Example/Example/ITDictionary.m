//
//  ITDictionary.m
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITDictionary.h"

#define kInfoFilePathSuffix     @".info"
#define kIndexFilePathSuffix    @".index"
#define kDataFilePathSuffix     @".dz"
#define kSynFilePathSuffix      @".syn"

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
    NSURL *infoFileUrl = [NSURL URLWithString:self.infoFilePath];
}

#pragma -mark private methods
/**
 Load info and index file
 */

@end
