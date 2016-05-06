//
//  IndexBannerCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/9.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexBannerCell.h"

#import "XRCarouselView.h"
@interface IndexBannerCell()<XRCarouselViewDelegate>
{
    
}

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
    
        _carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 150) imageArray:arr2];
        _carouselView.frame = CGRectMake(0, 0, SCREENWITH, 150);
        //用代理处理图片点击，如果两个都实现，block优先级高于代理
        _carouselView.delegate = self;
        //设置每张图片的停留时间
        _carouselView.time = 5;
        //用block处理图片点击
        _carouselView.imageClickBlock = ^(NSInteger index) {
            NSLog(@"第%ld张图片被点击", index);
        };

        //设置分页控件的图片
//        [_carouselView setPageImage:[UIImage imageNamed:@"other"] andCurrentImage:[UIImage imageNamed:@"current"]];
        
        //设置分页控件的frame
        _carouselView.pagePosition = PositionBottomCenter;
        [self addSubview:_carouselView];
        

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

    return 150;
    
}
- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index
{
    
}
@end
