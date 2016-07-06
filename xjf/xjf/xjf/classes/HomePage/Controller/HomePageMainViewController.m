//
//  HomePageMainViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageMainViewController.h"
#import "HomePageSelectViewController.h"
#import "HomePageWikipediaViewController.h"
#import "HomePageSchoolViewController.h"
#import "HomePageEmployedViewController.h"
#import "SelectedScrollContentView.h"

@interface HomePageMainViewController ()
@property (nonatomic, strong) HomePageSelectViewController *selectViewController;
@property (nonatomic, strong) HomePageWikipediaViewController *wikipediaViewController;
@property (nonatomic, strong) HomePageSchoolViewController *schoolViewController;
@property (nonatomic, strong) HomePageEmployedViewController *employedViewController;

@property (nonatomic, strong) SelectedScrollContentView *selectedScrollContentView;
@end

@implementation HomePageMainViewController

- (void)loadView
{
    [super loadView];
    
    @weakify(self)
    self.selectedScrollContentView = [[SelectedScrollContentView alloc]initWithFrame:self.view.bounds targetViewController:self addChildViewControllerBlock:^{
        @strongify(self)
        self.selectViewController = [[HomePageSelectViewController alloc] init];
        _selectViewController.title = @"精选";
        [self addChildViewController:_selectViewController];
        
        self.wikipediaViewController = [[HomePageWikipediaViewController alloc] init];
        _wikipediaViewController.title = @"百科";
        [self addChildViewController:_wikipediaViewController];
        
        self.schoolViewController = [[HomePageSchoolViewController alloc] init];
        _schoolViewController.title = @"学堂";
        [self addChildViewController:_schoolViewController];
        
        self.employedViewController = [[HomePageEmployedViewController alloc] init];
        _employedViewController.title = @"从业";
        [self addChildViewController:_employedViewController];
    }];
    self.view = _selectedScrollContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self extendheadViewFor:Index];
}

- (void)changCurrunViewLocation:(NSInteger)index
{
    self.selectedScrollContentView.contentScrollView.contentOffset = CGPointMake(index * self.view.frame.size.width, 0);
}


@end
