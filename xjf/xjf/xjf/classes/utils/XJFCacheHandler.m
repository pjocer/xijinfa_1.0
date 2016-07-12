//
//  XJFCacheHandler.m
//  xjf
//
//  Created by PerryJ on 16/7/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFCacheHandler.h"
#import <SDWebImage/SDImageCache.h>
#import "XJMarket.h"

@implementation XJFCacheHandler
+(void)load {
    [super load];
    XJFCacheHandler *handler = [XJFCacheHandler sharedInstance];
    [[NSFileManager defaultManager] createDirectoryAtPath:[handler plistFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    [handler createFileAtPath:[handler pathFor:LABEL_FILE]];
    [handler createFileAtPath:[handler pathFor:SEARCH_FILE]];
    [handler createFileAtPath:[handler pathFor:USERLESSONS_FILE]];
    [handler createFileAtPath:[handler pathFor:SHOPPINGCART_FILE]];
    NSArray *labels = [NSArray new];
    NSArray *searchs = [NSArray new];
    [labels writeToFile:[handler pathFor:LABEL_FILE] atomically:YES];
    [searchs writeToFile:[handler pathFor:SEARCH_FILE] atomically:YES];
    NSMutableDictionary *_my_lessons = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray new], MY_LESSONS_XUETANG, [NSArray new], MY_LESSONS_PEIXUN, nil];
    NSMutableDictionary *_shopping_cart = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray new], XJ_XUETANG_SHOP, [NSArray new], XJ_CONGYE_PEIXUN_SHOP, nil];
    [_my_lessons writeToFile:[handler pathFor:USERLESSONS_FILE] atomically:YES];
    [_shopping_cart writeToFile:[handler pathFor:SHOPPINGCART_FILE] atomically:YES];
}
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XJFCacheHandler *handler = nil;
    dispatch_once(&onceToken, ^{
        handler = [[XJFCacheHandler alloc] initSingle];
    });
    return handler;
}
-(instancetype)initSingle {
    self = [super init];
    if (self) {
        [self performSelector:@selector(initHotSearched) withObject:nil afterDelay:5];
    }
    return self;
}
- (void)initHotSearched {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:hot_search RequestMethod:GET];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if ([result[@"errCode"] integerValue] == 0) {
            for (NSString *temp in result[@"result"]) {
                [self addSearch:temp];
            }
        }else {
            [[ZToastManager ShardInstance] showtoast:result[@"errMsg"]];
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"请求热门搜索列表失败"];
    }];
}
-(void)clean {
    [[SDImageCache sharedImageCache] cleanDisk];
}
-(void)cleanDiskOnCompeletion:(dispatch_block_t)compeletion {
    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:compeletion];
}
-(void)clear {
    [self clearDiskOnCompeletion:nil];
    
}
-(void)clearDiskOnCompeletion:(dispatch_block_t)compeletion {
    [self removeFileAtPath:[self pathFor:USERLESSONS_FILE]];
    [self removeFileAtPath:[self pathFor:SEARCH_FILE]];
    [self removeFileAtPath:[self pathFor:LABEL_FILE]];
    [self removeFileAtPath:[self pathFor:SHOPPINGCART_FILE]];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:compeletion];
}
-(BOOL)removeFileAtPath:(NSString *)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%@",[error description]);
        return NO;
    }else {
        return YES;
    }
}
-(NSString *)getSize {
    unsigned long iLength = [[SDImageCache sharedImageCache] getSize]/1024.0;
    iLength += [self folderSizeAtPath:[self plistFolderPath]];
    if(iLength > 1024.0) {
        iLength = iLength/1024.0;
        NSString *sLength = [NSString stringWithFormat:@"%lu",iLength];
        return [sLength stringByAppendingString:@"M"];
    } else {
        NSString *sLength = [NSString stringWithFormat:@"%lu",iLength];
        return [sLength stringByAppendingString:@"K"];
    }
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (NSString *)plistFolderPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"plistFolder"];
}
- (NSString *)pathFor:(NSString *)fileName {
    return [[self plistFolderPath] stringByAppendingPathComponent:fileName];
}
- (BOOL)createFileAtPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        return [manager createFileAtPath:path contents:nil attributes:nil];
    }
    return nil;
}

@end

@implementation XJFCacheHandler (Recently)

- (void)clearRecentlySearched {
    NSArray *array = [NSArray array];
    [array writeToFile:[self pathFor:SEARCH_FILE] atomically:YES];
}

- (NSMutableArray<NSString *> *)recentlySearched {
    return [NSMutableArray arrayWithContentsOfFile:[self pathFor:SEARCH_FILE]];
}
- (void)addSearch:(NSString *)search {
    NSMutableArray *array = [[NSMutableArray arrayWithContentsOfFile:[self pathFor:SEARCH_FILE]] mutableCopy];
    if (![array containsObject:search]) {
        [array insertObject:search atIndex:0];
        if (array.count > 10) {
            [array removeLastObject];
        }
        [array writeToFile:[self pathFor:SEARCH_FILE] atomically:YES];
    }
}

- (void)addLabels:(NSString *)label {
    NSMutableArray *array = [[NSMutableArray arrayWithContentsOfFile:[self pathFor:LABEL_FILE]] mutableCopy];
    if (![array containsObject:label]) {
        [array insertObject:label atIndex:0];
        if (array.count > 10) {
            [array removeObjectAtIndex:10];
        }
        [array writeToFile:[self pathFor:LABEL_FILE] atomically:YES];
    }
}

- (NSMutableArray<NSString *> *)recentlyUsedLabels {
    return [NSMutableArray arrayWithContentsOfFile:[self pathFor:LABEL_FILE]];
}

@end
