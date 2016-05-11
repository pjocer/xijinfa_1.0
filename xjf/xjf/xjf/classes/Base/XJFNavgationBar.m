//
//  XJFNavgationBar.m
//  xjf
//
//  Created by PerryJ on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFNavgationBar.h"
#import "xjfConfigure.h"
@implementation XJFNavgationBar

+(instancetype)sharedBar {
    static XJFNavgationBar *bar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bar = [[XJFNavgationBar alloc] _initWithFrame:CGRectMake(0, 0, SCREENWITH, HEADHEIGHT)];
    });
    return bar;
}

- (instancetype) _initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end

@implementation XJFNavgationBar (Setting)

-(void)setBarStyle:(XJFNavgationBarStyle)barStyle {
    if (barStyle == XJFNavgationBarStyleDefault) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 15+(HEADHEIGHT-20-20)/2, 35, 35)];
        iconImage.image = [UIImage imageNamed:@"Logo"];
        [_headView addSubview:iconImage];
        
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+8, 21+(HEADHEIGHT-20-20)/2, self.view.frame.size.width/2, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = FONT(16);
        [_headView addSubview:_titleLabel];
        //
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 20+(HEADHEIGHT-20-25)/2, 30, 25);
        _backButton.tag =0;
        _backButton.hidden = NO;
        [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_backButton];
        //
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
        _rightButton.tag =1;
        _rightButton.hidden=YES;
        _rightButton.titleLabel.font =FONT(14);
        [_rightButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_rightButton];
        [_headView addShadow];
        [self.view addSubview:_headView];
    }
}

@end