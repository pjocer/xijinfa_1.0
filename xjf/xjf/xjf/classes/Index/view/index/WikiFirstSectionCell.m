//
//  WikiFirstSectionCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiFirstSectionCell.h"
#import "WikiPediaCategoriesModel.h"

@interface WikiFirstSectionCell ()
@property (nonatomic, strong) WikiPediaCategoriesModel *wikiPediaCategoriesModel;
@end

@implementation WikiFirstSectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self requestCategoriesData:talkGridCategories method:GET];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray) {
        _dataArray = dataArray;
    }
    
    // 搭建界面，九宫格
#define kAppViewW 70
#define kAppViewH 30
#define kColCount 4
#define kStartY   0
    
    CGFloat marginX = (self.contentView.bounds.size.width - kColCount * kAppViewW) / (kColCount + 1);
    CGFloat marginY = 5;
    
    for (int i = 0; i < self.tempArray.count; i++) {

        int row = i / kColCount;

        int col = i % kColCount;
        
        CGFloat x = marginX + col * (marginX + kAppViewW);
        CGFloat y = kStartY + marginY + row * (marginY + kAppViewH);
        
        UIButton *appView = [UIButton buttonWithType:UIButtonTypeSystem];
        appView.frame = CGRectMake(x, y, kAppViewW, kAppViewH);
        [self.contentView addSubview:appView];
        WikiPediaCategoriesDataModel *model = self.tempArray[i];
        if (i == self.tempArray.count - 1) {
            [appView setTitle:@"更多..." forState:UIControlStateNormal];
        }
        else{
            [appView setTitle:model.name forState:UIControlStateNormal];
        }
        
        appView.tag = i;
        appView.layer.masksToBounds = YES;
        appView.layer.cornerRadius = 15;
        appView.layer.borderWidth = 1;
        appView.layer.borderColor = [UIColor xjfStringToColor:@"#c7c7cc"].CGColor;
        [appView addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
         appView.titleLabel.font = FONT12;
        [appView setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];

    }
}
- (void)click:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wikiFirstSectionCell:DidSelectedItemAtIndex:WithOtherObject:)]) {
        WikiPediaCategoriesDataModel *model = self.tempArray[sender.tag];
        [self.delegate wikiFirstSectionCell:self DidSelectedItemAtIndex:sender.tag WithOtherObject:model.ID];
        }
}

- (void)requestCategoriesData:(APIName *)api method:(RequestMethod)method
{
    __weak typeof (self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
    
    //Categories
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        
        __strong typeof (self)sSelf = wSelf;
        
        id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        sSelf.wikiPediaCategoriesModel = [[WikiPediaCategoriesModel alloc] init];
        [sSelf.wikiPediaCategoriesModel setValuesForKeysWithDictionary:result];

        self.tempArray = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            WikiPediaCategoriesDataModel *model = self.wikiPediaCategoriesModel.resultModel.dataModelArray[i];
            [self.tempArray addObject:model];
        }

        self.dataArray = self.wikiPediaCategoriesModel.resultModel.dataModelArray;
        
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
    }];
}

@end
