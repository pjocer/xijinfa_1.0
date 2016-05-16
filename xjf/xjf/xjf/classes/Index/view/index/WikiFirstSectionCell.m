//
//  WikiFirstSectionCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "WikiFirstSectionCell.h"
//#import "WikiPediaCategoriesModel.h"
//
//@interface WikiFirstSectionCell ()
//@property (nonatomic, strong) WikiPediaCategoriesModel *wikiPediaCategoriesModel;
//@end

@implementation WikiFirstSectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.label = [[UILabel alloc] init];
        self.label.font = FONT15;
        self.label.text = @"XXX";
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
//        self.label.backgroundColor = [UIColor redColor];
        self.label.layer.borderColor = [UIColor xjfStringToColor:@"#c7c7cc"].CGColor;
        self.label.layer.borderWidth = 1;
        self.label.layer.masksToBounds = YES;
        self.label.layer.cornerRadius = 12;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(8);
        make.left.equalTo(self.contentView).with.offset(8);
        make.bottom.equalTo(self.contentView).with.offset(-8);
        make.right.equalTo(self.contentView).with.offset(-8);
        
    }];
}

//- (void)setDataArray:(NSMutableArray *)dataArray
//{
//    if (dataArray) {
//        _dataArray = dataArray;
//    }
//    
//    
//    
//         //2.完成布局设计
//    
//         //三列
//         int totalloc=3;
//         CGFloat appvieww=10;
//         CGFloat appviewh=10;
//    
//         CGFloat margin=(self.contentView.frame.size.width-totalloc*appvieww)/(totalloc+1);
//         for (int i=0; i<_dataArray.count; i++) {
//                 int row=i/totalloc;//行号
//                 //1/3=0,2/3=0,3/3=1;
//                 int loc=i%totalloc;//列号
//        
//                 CGFloat appviewx=margin+(margin+appvieww)*loc;
//                 CGFloat appviewy=margin+(margin+appviewh)*row;
//        
//        
//                 //创建uiview控件
//                 UIView *appview=[[UIView alloc]initWithFrame:CGRectMake(appviewx, appviewy, appvieww, appviewh)];
//                 [appview setBackgroundColor:[UIColor purpleColor]];
//                 [self.contentView addSubview:appview];
//
//        
//                 //创建按钮
//                 UIButton *appbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//                 appbtn.frame= CGRectMake(10, 70, 60, 20);
//                 WikiPediaCategoriesDataModel *model = self.dataArray[i];
//                 [appbtn setTitle:model.name forState:UIControlStateNormal];
//                 appbtn.titleLabel.font=[UIFont systemFontOfSize:12.0];
//                 [appview addSubview:appbtn];
//        
//                 [appbtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//             }
//    
//    
//}
//- (void)requestCategoriesData:(APIName *)api method:(RequestMethod)method
//{
//    __weak typeof (self) wSelf = self;
//    XjfRequest *request = [[XjfRequest alloc]initWithAPIName:api RequestMethod:method];
//    
//    //Categories
//    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
//        
//        __strong typeof (self)sSelf = wSelf;
//        
//        id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//        sSelf.wikiPediaCategoriesModel = [[WikiPediaCategoriesModel alloc] init];
//        [sSelf.wikiPediaCategoriesModel setValuesForKeysWithDictionary:result];
//
//        self.dataArray = self.wikiPediaCategoriesModel.resultModel.dataModelArray;
//        
//    } failedBlock:^(NSError * _Nullable error) {
//        [[ZToastManager ShardInstance]showtoast:@"网络连接失败"];
//    }];
//}

@end
