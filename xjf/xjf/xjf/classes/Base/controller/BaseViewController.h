//
//  BaseViewController.h
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xjfConfigure.h"
#import "Masonry.h"
#import "BaseViewCell.h"
#import "ZToastManager.h"

@interface BaseViewController : UIViewController
{
    
}
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,assign)BOOL isIndex;
@property(nonatomic,strong)NSString* navTitle;
-(BOOL)isLogin;
-(void)headerClickEvent:(id)sender;
-(UIView *)footerView:(NSString*)msg;
@end
