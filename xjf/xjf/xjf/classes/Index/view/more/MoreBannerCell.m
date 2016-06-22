//
//  MoreBannerCell.m
//  xjf
//
//  Created by yiban on 16/4/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MoreBannerCell.h"
#import "XRCarouselView.h"

@interface MoreBannerCell () <XRCarouselViewDelegate>
@property (nonatomic, strong) XRCarouselView *carouselView;
@end

@implementation MoreBannerCell

- (void)setCallBack:(void (^)(BEventType, UIView *, id, id, NSIndexPath *))callback {
    self.actionBlock = callback;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 150) imageArray:nil];
        _carouselView.changeMode = ChangeModeFade;
        _carouselView.delegate = self;
        _carouselView.imageClickBlock = ^(NSInteger index) {
            NSLog(@"第%ld张图片被点击", (long)index);
        };
        _carouselView.pagePosition = PositionBottomCenter;
        [self addSubview:_carouselView];
    }
    return self;
}

/// 根据数据模型来显示内容
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath {
    self.key = key;
    self.data = model;
    self.indexPath = indexPath;
}

/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model {
    return 150;
}

- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index {

}

@end
