//
//  ITDictionary.h
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITEntry;

@interface ITDictionary : NSObject

@property (strong, nonatomic) NSString        *infoFilePath;      // path to info file.
@property (strong, nonatomic) NSString        *indexFilePath;     // path to index file.
@property (strong, nonatomic) NSString        *dataFilePath;      // path to data file.
@property (strong, nonatomic) NSString        *synFilePath;       // path to synonym file.
@property (strong, readonly, nonatomic) NSArray         *entries;           // list of entries initialized at same time with ITDictionary object.

/**
 Init new ITDictionary object with its' data folder.
 */
- (id) initWithDictionaryFolder:(NSString *)dictionaryFolderPath;

/**
 Init new ITDictionary object with its' data files.
 */
- (id) initWithInfoFile:(NSString *)infoFilePath indexFile:(NSString *)indexFilePath dataFile:(NSString *)dataFilePath synFile:(NSString *)synFilePath;

/**
 Load dictionary data including: info file, index file, syn file.
 Data is loaded asynchronously.
 */
- (void)loadDictionary;

@end