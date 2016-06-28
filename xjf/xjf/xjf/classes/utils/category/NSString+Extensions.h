//
//  NSString+Extensions.h
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@interface NSString (Extensions)
- (NSString *)lowercaseFirstCharacter;

- (NSString *)uppercaseFirstCharacter;

- (BOOL)isEmpty;

- (NSString *)replaceNullString;

- (NSString *)trim;

- (NSString *)trimTheExtraSpaces;

- (NSString *)escapeHTML;

+ (NSString *)filterHTML:(NSString *)str;

- (NSString *)stringByDecodingXMLEntities;

- (NSString *)md5;

- (NSString *)md5ForUTF16;

- (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (NSMutableArray *)tokenizationStringByNSStringEnumerationOptions:(NSStringEnumerationOptions)opts;

- (NSString *)languageForString;

- (NSMutableArray *)analyseTextOfSentences;

//
// 获取Documents路径
+ (NSString *)documentPath;

// 获取缓存路径
+ (NSString *)cachePath;

+ (NSString *)imageCachePath;

// 本地购物车路径
+ (NSString *)localShoppingCartPath;

//! 是否是合法邮箱
- (BOOL)isValidEmail;

//! 是否是合法号码
- (BOOL)isValidPhoneNumber;

//! 是否是合法的18位身份证号码
- (BOOL)isValidPersonID;

/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
- (BOOL)areaCode:(NSString *)code;

//! 根据文件名返回路径
+ (NSString *)pathWithFileName:(NSString *)fileName;

+ (NSString *)pathWithFileName:(NSString *)fileName ofType:(NSString *)type;

// 根据秒数返回日期
+ (NSString *)dateWithSeconds:(NSUInteger)seconds;

/**
 *  根据秒数反回: 时 分 秒
 *
 *  @param seconds 秒
 *
 *  @return 时分秒
 */
+ (NSString *)timeformatFromSeconds:(NSInteger)seconds;

/**
 *  获取系统时间
 *
 *  @return 现在的时间
 */
+ (NSString *)getSystemDate;


/**
 *  计算缓存文件的大小的M
 *
 *  @param filePath 文件路径
 *
 *  @return 缓存文件的大小的M
 */
+ (long long) fileSizeAtPath:(NSString*) filePath;

/**
 *  遍历文件夹获得文件夹大小，
 *
 *  @param folderPath 文件路径
 *
 *  @return 返回多少M
 */
+ (float ) folderSizeAtPath:(NSString*) folderPath;

/**
 *  计算SDWebImage缓存大小
 *
 *  @return 缓存大小
 */
+ (NSString *)sdCacesSize;

/**
 *  删除缓存
 *
 *  @param path    路径
 *  @param success successBlock
 *  @param failure failureBlock
 */
+ (void)deletecachePath:(NSString *)path
               Success:(void(^)())success
            WithFailure:(void (^)())failure;
@end
