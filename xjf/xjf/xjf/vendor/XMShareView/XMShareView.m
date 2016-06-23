//
//  XMShareView.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareView.h"

#import "VerticalUIButton.h"
#import "CommonMarco.h"
#import "XMShareWeiboUtil.h"
#import "XMShareWechatUtil.h"
#import "XMShareQQUtil.h"
#import "LPPopup.h"

#define ShareRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//  水平间隔
static const CGFloat itemHorPadding = 20.0;

//  垂直间隔
static const CGFloat itemVerPadding = 20.0;


//  每行显示数量
static const NSInteger numbersOfItemInLine = 3;

@implementation XMShareView

- (id)initWithFrame:(CGRect)frame type:(NSString *)type {

    self = [super initWithFrame:frame];
    if (self) {
        //  点击关闭
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
        [self addGestureRecognizer:tap];
        tap = nil;
        self.userInteractionEnabled = YES;


        [self configureData];
        [self initUI:type];

    }
    return self;

}

/**
 *  加载视图
 */
- (void)initUI:(NSString *)type {

    //  背景色黑色半透明
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];


    CGFloat bgViewWidth = SIZE_OF_SCREEN.width * 4 / 5;// itemWidth * numbersOfItemInLine + itemHorPadding * (numbersOfItemInLine + 1);
    CGFloat bgViewHeight = SIZE_OF_SCREEN.height / 2;//itemHeight * 2 + itemVerPadding * 4 +120;
    CGFloat bgViewX = (SIZE_OF_SCREEN.width - bgViewWidth) / 2;
    CGFloat bgViewY = (SIZE_OF_SCREEN.height - bgViewHeight) / 2;
    //item 宽高
    CGFloat itemWidth = (SIZE_OF_SCREEN.width * 4 / 5 - 20 * 4) / 3;
    CGFloat itemHeight = itemWidth;
    //起点
    CGFloat startY = 0;

    //  居中白色视图
    UIView *shareActionView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewWidth, bgViewHeight)];
    ViewRadius(shareActionView, 2);
    shareActionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareActionView];
    //info
    if (type.length > 0) {
        startY = bgViewHeight / 4;
        //
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, (bgViewHeight / 4 - bgViewHeight / 4 / 3) / 2, bgViewWidth - 40, bgViewHeight / 4 / 3)];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:14];
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 0;
        title.text = type;
        CGSize size = [title sizeThatFits:CGSizeMake(title.frame.size.width, MAXFLOAT)];
        title.frame = CGRectMake(title.frame.origin.x, (bgViewHeight / 4 - size.height) / 2, title.frame.size.width, size.height);

        [shareActionView addSubview:title];
        title = nil;

        //
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, startY, bgViewWidth - 20, 1)];
        line.backgroundColor = ShareRGB(0xe1e1e1);
        [shareActionView addSubview:line];
        line = nil;
    } else {
        bgViewHeight = bgViewHeight - bgViewHeight / 4;
        shareActionView.frame = CGRectMake(bgViewX, bgViewY, bgViewWidth, bgViewHeight);
    }

    //
    for (int i = 0; i < iconList.count; i++) {

        VerticalUIButton *tempButton;
        UIImage *img = [UIImage imageNamed:iconList[i]];

        int row = i / numbersOfItemInLine;

        int col = i % numbersOfItemInLine;

        CGFloat x = (itemWidth + itemHorPadding) * col + itemHorPadding;

        CGFloat y = startY + (itemHeight + itemVerPadding) * row + itemVerPadding;

        tempButton = [[VerticalUIButton alloc] initWithFrame:CGRectMake(x, y, itemWidth, itemHeight)];
        tempButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tempButton setImage:img forState:UIControlStateNormal];
        [tempButton setTitle:textList[i] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];

        if ([textList[i] isEqualToString:NSLocalizedString(@"微信好友", nil)]) {

            tempButton.tag = SHARE_ITEM_WEIXIN_SESSION;

        } else if ([textList[i] isEqualToString:NSLocalizedString(@"朋友圈", nil)]) {

            tempButton.tag = SHARE_ITEM_WEIXIN_TIMELINE;

        } else if ([textList[i] isEqualToString:NSLocalizedString(@"QQ", nil)]) {

            tempButton.tag = SHARE_ITEM_QQ;

        } else if ([textList[i] isEqualToString:NSLocalizedString(@"QQ空间", nil)]) {

            tempButton.tag = SHARE_ITEM_QZONE;

        } else if ([textList[i] isEqualToString:NSLocalizedString(@"微博", nil)]) {

            tempButton.tag = SHARE_ITEM_WEIBO;

        } else if ([textList[i] isEqualToString:NSLocalizedString(@"复制链接", nil)]) {

            tempButton.tag = SHARE_ITEM_COPY;

        }

        [shareActionView addSubview:tempButton];
    }

    VerticalUIButton *closeButton = [[VerticalUIButton alloc] initWithFrame:CGRectMake((bgViewWidth - itemWidth) / 2, bgViewHeight - itemHeight / 1.5, itemWidth, itemHeight)];
    [closeButton setImage:[UIImage imageNamed:@"shareclose"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = SHARE_ITEM_CLOSE;
    [shareActionView addSubview:closeButton];


}


/**
 *  初始化数据
 */
- (void)configureData {

    /**
     *  判断应用是否安装，可用于是否显示
     *  QQ和Weibo分别有网页版登录与分享，微信目前不支持
     */
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]];

    iconList = [[NSMutableArray alloc] init];
    textList = [[NSMutableArray alloc] init];

    if (hadInstalledWeixin) {

        [iconList addObject:@"weixinchat"];
        [iconList addObject:@"weixinzone"];
        [textList addObject:NSLocalizedString(@"微信好友", nil)];
        [textList addObject:NSLocalizedString(@"朋友圈", nil)];

    }

    if (hadInstalledQQ) {

        [iconList addObject:@"qqchat"];
        [iconList addObject:@"qqzone"];
        [textList addObject:NSLocalizedString(@"QQ", nil)];
        [textList addObject:NSLocalizedString(@"QQ空间", nil)];

    }

    if (hadInstalledWeibo) {

        [iconList addObject:@"sinaweibo"];
        [textList addObject:NSLocalizedString(@"微博", nil)];

    }

    [iconList addObject:@"sharecopylink"];
    [textList addObject:NSLocalizedString(@"复制链接", nil)];
}

- (void)clickActionButton:(VerticalUIButton *)sender {

    if (sender.tag == SHARE_ITEM_WEIXIN_SESSION) {

        [self shareToWeixinSession];

    } else if (sender.tag == SHARE_ITEM_WEIXIN_TIMELINE) {

        [self shareToWeixinTimeline];

    } else if (sender.tag == SHARE_ITEM_QQ) {

        [self shareToQQ];

    } else if (sender.tag == SHARE_ITEM_QZONE) {

        [self shareToQzone];

    } else if (sender.tag == SHARE_ITEM_WEIBO) {

        [self shareToWeibo];

    } else if (sender.tag == SHARE_ITEM_COPY) {

        [self shareToLink];

    } else if (sender.tag == SHARE_ITEM_CLOSE) {

        [self clickClose];

    } else

        [self clickClose];

}

- (void)shareToWeixinSession {

    XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    util.shareImage = self.shareImage;
    [util shareToWeixinSession];

}

- (void)shareToWeixinTimeline {

    XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    util.shareImage = self.shareImage;
    [util shareToWeixinTimeline];

}

- (void)shareToQQ {
    XMShareQQUtil *util = [XMShareQQUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    util.shareImage = self.shareImage;
    [util shareToQQ];
}

- (void)shareToQzone {
    XMShareQQUtil *util = [XMShareQQUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    util.shareImage = self.shareImage;
    [util shareToQzone];
}

- (void)shareToWeibo {

    XMShareWeiboUtil *util = [XMShareWeiboUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    util.shareImage = self.shareImage;
    [util shareToWeibo];

}

- (void)shareToLink {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.shareUrl];
    LPPopup *popup = [LPPopup popupWithText:@"链接地址已复制到粘帖板！"];
    [popup showInView:self
        centerAtPoint:self.center
             duration:kLPPopupDefaultWaitDuration
           completion:nil];
}

- (void)clickClose {
    [UIView animateWithDuration:1 animations:^{
        self.hidden = YES;
    }];
}


@end
