//
//  HomePageBanderCell.h
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseCollectionViewCell.h"
#import "XRCarouselView.h"
#import "BannerModel.h"
@interface HomePageBanderCell : XJFBaseCollectionViewCell
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) XRCarouselView *carouselView;
@end
