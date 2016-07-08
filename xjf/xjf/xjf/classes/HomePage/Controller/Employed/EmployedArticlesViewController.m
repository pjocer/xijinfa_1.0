//
//  EmployedArticlesViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/7/8.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedArticlesViewController.h"
#import "EmploymentInformationViewController.h"
#import "SelectedScrollContentView.h"
#import "HomePageConfigure.h"

@interface EmployedArticlesViewController ()
@property (nonatomic, strong) ProjectListByModel *projectListByModel;
//证券从业
@property (nonatomic, strong) NSString *employedSecuritiesID;
@property (nonatomic, strong) EmploymentInformationViewController *securitiesSection;
//期货从业
@property (nonatomic, strong) NSString *employedFuturesID;
@property (nonatomic, strong) EmploymentInformationViewController *futuresSection;
//基金从业
@property (nonatomic, strong) NSString *employedFundID;
@property (nonatomic, strong) EmploymentInformationViewController *fundSection;
@end

@implementation EmployedArticlesViewController
//securitiesSection, //证券从业
//fundSection,       //基金从业
//futuresSection     //期货从业

- (void)loadView
{
    [super loadView];
    @weakify(self)
    SelectedScrollContentView *selectedScrollContentView = [[SelectedScrollContentView alloc]initWithFrame:self.view.bounds targetViewController:self addChildViewControllerBlock:^{
        @strongify(self)
        self.securitiesSection = [[EmploymentInformationViewController alloc] init];
        _securitiesSection.title = @"证券";
        [self addChildViewController:_securitiesSection];
        
        self.fundSection = [[EmploymentInformationViewController alloc] init];
        _fundSection.title = @"基金";
        [self addChildViewController:_fundSection];
        
        self.futuresSection = [[EmploymentInformationViewController alloc] init];
        _futuresSection.title = @"期货";
        [self addChildViewController:_futuresSection];

    }];
    self.view = selectedScrollContentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.articlesType) {
        case EmploymentInformation: {
        self.navigationItem.title = @"从业资讯";
        }
            break;
        case Guide: {
        self.navigationItem.title = @"报考指南";
        }
            break;
        case TestTime: {
        self.navigationItem.title = @"考试时间";
        }
            break;
        default:
            break;
    }
    [self requesProjectListDat:specials method:GET];
}

//ProjectListByModel
- (void)requesProjectListDat:(APIName *)api method:(RequestMethod)method {
    @weakify(self)
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        self.projectListByModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
        
        for (ProjectList *model in self.projectListByModel.result.data) {
            if ([model.title isEqualToString:@"从业资讯"] && self.articlesType == EmploymentInformation) {
                [self setID:model];
            }
            else if ([model.title isEqualToString:@"报考指南 "] && self.articlesType == Guide) {
                [self setID:model];
            }
            else if ([model.title isEqualToString:@"考试时间"] && self.articlesType == TestTime) {
                [self setID:model];
            }
        }
  
    } failedBlock:^(NSError *_Nullable error) {
    }];
}

- (void)setID:(ProjectList *)model
{
    for (ProjectList *tempModel in model.children) {
        if ([tempModel.title isEqualToString:@"证卷从业"]) {
            _securitiesSection.ID = tempModel.id;
        }
        else if ([tempModel.title isEqualToString:@"期货从业"]) {
            _futuresSection.ID = tempModel.id;
        }
        else if ([tempModel.title isEqualToString:@"基金从业"]) {
            _fundSection.ID = tempModel.id;
        }
    }
}


@end
