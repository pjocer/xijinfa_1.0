//
//  WikiPediaCategoriesModel.m
//  xjf
//
//  Created by Hunter_wang on 16/5/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiPediaCategoriesModel.h"

@implementation WikiPediaCategoriesDataModel
//+(JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"des"}];
//}
//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    return YES;
//}
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}






@end

@implementation WikiPediaCategoriesResultModel
//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    return YES;
//}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"data"]) {
        self.dataModelArray = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            WikiPediaCategoriesDataModel *model = [[WikiPediaCategoriesDataModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataModelArray addObject:model];
        }
    }
    
    
}





@end

@implementation WikiPediaCategoriesModel
//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    return YES;
//}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];

    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"result"]) {
        self.resultModel = [[WikiPediaCategoriesResultModel alloc] init];
        [self.resultModel setValuesForKeysWithDictionary:value];
    }
    
}


@end




