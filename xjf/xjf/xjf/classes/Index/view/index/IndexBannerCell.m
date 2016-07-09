//
//  IndexBannerCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/9.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexBannerCell.h"
#import "XRCarouselView.h"
#import "BannerModel.h"

@interface IndexBannerCell () <XRCarouselViewDelegate>
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) XRCarouselView *carouselView;
@end

@implementation IndexBannerCell

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback {
    self.actionBlock = callback;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 175) imageArray:nil];
        [self.contentView addSubview:_carouselView];
        _carouselView.changeMode = ChangeModeFade;
        _carouselView.delegate = self;
        [self requestBannerData:appHomeCarousel method:GET];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.carouselView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

/// 根据数据模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath {
    self.key = key;
    self.data = model;
    self.indexPath = indexPath;
}

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model {
    return 175;
}

- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index {
    if (self.actionBlock && self.bannermodel.result.data.count != 0 && self.bannermodel.result.data) {
        self.actionBlock(BEventType_Unknown, nil, self.carouselView, self.bannermodel.result.data[index], self.indexPath);
    }
}

- (void)requestBannerData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    NSMutableArray *tempArray = [NSMutableArray array];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];

    // banner model
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.bannermodel = [[BannerModel alloc] initWithData:responseData error:nil];
        for (BannerResultModel *model in sSelf.bannermodel.result.data) {
            if (model.cover && model.cover.count > 0) {
                BannerCover *cover = model.cover.firstObject;
                [tempArray addObject:cover.url];
            }
        }
        sSelf.carouselView.imageArray = tempArray;
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}

@end
