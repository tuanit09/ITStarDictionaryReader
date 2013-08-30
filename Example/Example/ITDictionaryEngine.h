//
//  ITDictionaryEngine.h
//  Example
//
//  Created by Nguyen Anh Tuan on 30/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITDictionary;

@protocol ITDictionaryDelegate <NSObject>

- (void)dictionaryEngineWillSearchInDictionary:(ITDictionary *)dictionary;
- (void)dictionaryEngineDidSearchInDictionary:(ITDictionary *)dictionary withResult:(NSArray *)results;

@end

@interface ITDictionaryEngine : NSObject

+ (void)searchForWord:(NSString *)word inDictionary:(ITDictionary *)dictionary forTarget:(id<ITDictionaryDelegate>)delegate;

@end
