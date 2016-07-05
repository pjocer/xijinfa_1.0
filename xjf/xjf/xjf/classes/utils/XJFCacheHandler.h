//
//  XJFCacheHandler.h
//  xjf
//
//  Created by PerryJ on 16/7/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LABEL_FILE @"label.plist"
#define SEARCH_FILE @"search.plist"
#define SHOPPINGCART_FILE @"shopping_cart.plist"
#define USERLESSONS_FILE @"user_lessons.plist"
@interface XJFCacheHandler : NSObject

+ (nonnull instancetype)sharedInstance;

- (nonnull instancetype)init NS_UNAVAILABLE;
/**
 *  Remove all cache contained image/json/data/plist
 */
- (void)clear;
- (void)clearDiskOnCompeletion:(nullable dispatch_block_t)compeletion;
/**
 *  Remove all expired cached image from disk
 */
- (void)clean;
- (void)cleanDiskOnCompeletion:(nullable dispatch_block_t)compeletion;
/**
 *  Get current used disk Cache file size
 *
 *  @return file size
 */
- (nullable NSString *)getSize;
- (nullable NSString *)pathFor:(nonnull NSString *)fileName;
- (BOOL)createFileAtPath:(nonnull NSString *)path;
- (BOOL)removeFileAtPath:(nonnull NSString *)path;
@end

@interface XJFCacheHandler (Recently)
/**
 *  @return Recently Used Topic Labels
 */
- (nullable NSMutableArray <NSString *> *)recentlyUsedLabels;
/**
 *  @return Recently Searched Strings
 */
- (nullable NSMutableArray <NSString *> *)recentlySearched;
/**
 *  Write To Plist File When User Searched
 *
 *  @param Search Content
 */
- (void)addSearch:(nonnull NSString *)search;
/**
 *  Write To Plist File When User Added Topic Labels
 *
 *  @param Label Content
 */
- (void)addLabels:(nonnull NSString *)label;
/**
 *  Clear Content Which Is User Recently Searched
 */
- (void)clearRecentlySearched;

@end