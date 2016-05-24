//
//  TalkGridModel.m
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TalkGridModel.h"

@implementation TalkGridModel

//- (void)setValue:(id)value forKey:(NSString *)key
//{
//    [super setValue:value forKey:key];
//    if ([key isEqualToString:@"price"]) {
//        if ([[NSString stringWithFormat:@"%@",value] isEqualToString:@"-1"]) {
//            value = @"免费";
//        }
//    }
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    if ([key isEqualToString:@"view"]) {
//        _view_ = value;
//    }
//    if ([key isEqualToString:@"id"]) {
//        _id_ = value;
//    }
//    if ([key isEqualToString:@"video"]) {
//        NSArray *tempArray = value;
//        NSDictionary *tempDic = tempArray.firstObject;
//        _resolution = tempDic[@"resolution"];
//        _url = tempDic[@"url"];
//
//    }
//}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end



@implementation TablkResultModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end


@implementation TablkListModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end


@implementation TalkGridVideo
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
