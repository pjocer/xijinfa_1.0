//
//  TopicViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicViewController.h"
#import "IndexConfigure.h"
#import "SCNavTabBarController.h"
#import "MenuHrizontal.h"
#import "ScrollPageView.h"

@interface TopicViewController ()<MenuHrizontalDelegate,ScrollPageViewDelegate>
{
    
}
@property(nonatomic,strong)HomeView *mHomeView;;
@property(nonatomic,strong)ScrollPageView *mScrollPageView;
@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    self.isIndex = YES;
    self.navTitle =@"话题";
    [self extendheadView];
    [self initMainUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
}
//head UI
-(void)extendheadView
{
    //
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(SCREENWITH -110, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    downButton.tag =10;
    downButton.hidden=NO;
    downButton.titleLabel.font =FONT(14);
    [downButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [downButton setTitle:@"发表" forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView  addSubview:downButton];
    //
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    searchButton.tag =11;
    searchButton.hidden=NO;
    searchButton.titleLabel.font =FONT(14);
    [searchButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView  addSubview:searchButton];
}


-(void)headerClickEvent:(id)sender
{
    UIButton *btn =(UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if (self.navigationController) {
                if (self.navigationController.viewControllers.count == 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case 10://发表
        {
        }
            break;
        case 11://搜索 #import "SearchViewController.h"
        {
            SearchViewController *download =[[SearchViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
            
        }
            break;
        default:
            break;
    }
}
//mainui
-(void)initMainUI
{
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"全部",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"讨论",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"问答",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"话题",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  ];
    
    if (_mMenuHriZontal == nil) {
        _mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, self..frame.size.width, MENUHEIHT) ButtonItems:vButtonItemArray];
        _mMenuHriZontal.delegate = self;
    }
    //初始化滑动列表
    if (_mScrollPageView == nil) {
        _mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT)];
        _mScrollPageView.delegate = self;
    }
    [_mScrollPageView setContentOfTables:vButtonItemArray.count];
    //默认选中第一个button
    [_mMenuHriZontal clickButtonAtIndex:0];
    //-------
    [self.view addSubview:_mScrollPageView];
    [self.view addSubview:_mMenuHriZontal];
}

@end
