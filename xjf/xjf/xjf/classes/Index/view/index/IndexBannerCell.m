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
@interface IndexBannerCell()<XRCarouselViewDelegate>
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) XRCarouselView *carouselView;
@end

@implementation IndexBannerCell

-(void)setCallBack:(void(^)(BEventType,UIView*,id,id,NSIndexPath *))callback
{
    self.actionBlock=callback;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
       
        NSArray *arr2 = @[@"http://www.5068.com/u/faceimg/20140725173411.jpg", @"http://file27.mafengwo.net/M00/52/F2/wKgB6lO_PTyAKKPBACID2dURuk410.jpeg", @"http://file27.mafengwo.net/M00/B2/12/wKgB6lO0ahWAMhL8AAV1yBFJDJw20.jpeg"];
    
        self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 175) imageArray:arr2];
        [self.contentView addSubview:_carouselView];
        _carouselView.changeMode = ChangeModeFade;
        _carouselView.delegate = self;
         [self requestBannerData:appHomeCarousel method:GET];

    }
    return self;
}
-(void)dealloc
{
    self.actionBlock =nil;
    self.data=nil;
    self.key =nil;
    self.indexPath=nil;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.carouselView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
/// 根据数据模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath
{
    self.key =key;
    self.data =model;
    self.indexPath =indexPath;
    NSDictionary *dict =(NSDictionary*)model;
   
    
}
/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model
{
    NSDictionary *dict =(NSDictionary*)model;

    return 175;
    
}
- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index
{
    if (self.actionBlock) {
        self.actionBlock(BEventType_Unknow,nil,self.carouselView,nil,self.indexPath);
    }
}


- (void)requestBannerData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    NSMutableArray *tempArray = [NSMutableArray array];
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    
    //bannermodel
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        
        __strong typeof(self) sSelf = wSelf;
        [[ZToastManager ShardInstance] hideprogress];
        sSelf.bannermodel = [[BannerModel alloc] initWithData:responseData error:nil];
        for (BannerResultModel *model in sSelf.bannermodel.result.data) {
            [tempArray addObject:model.thumbnail];
        }
        sSelf.carouselView.imageArray = tempArray;
    }   failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
    
}

@end
