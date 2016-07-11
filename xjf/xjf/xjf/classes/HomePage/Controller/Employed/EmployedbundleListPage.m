//
//  EmployedbundleListPage.m
//  xjf
//
//  Created by Hunter_wang on 16/7/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedbundleListPage.h"
#import "EmployedbundleModel.h"
#import "XJMarket.h"
#import "OrderDetaiViewController.h"
#import "HomePageConfigure.h"

@interface EmployedbundleListPage ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIButton *addShoppingCart;
@property (nonatomic, strong) UIButton *nowPay;
@property (nonatomic, strong) EmployedbundleModel *employedbundleModel;
@end

@implementation EmployedbundleListPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAddShoppingCartButtonAndNowPayButton];
    [self initCollectionView];
    [self requesData:self.api_uri method:GET];
}

#pragma mark requestData

- (void)requesData:(APIName *)api method:(RequestMethod)method {
    
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    @weakify(self)
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        @strongify(self)
        self.employedbundleModel = [[EmployedbundleModel alloc] initWithData:responseData error:nil];
        [self.collectionView reloadData];
        [self.nowPay setTitle:[NSString stringWithFormat:@"购买整套课程 ￥%.2lf",self.employedbundleModel.result.price.floatValue / 100] forState:UIControlStateNormal];
    } failedBlock:^(NSError *_Nullable error) {
   
    }];
}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(KMargin, KMargin, KMargin, KMargin);
    _layout.minimumLineSpacing = KlayoutMinimumLineSpacing;
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectNull
                           collectionViewLayout:_layout];
     [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addShoppingCart.mas_top);
    }];
    
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    [_collectionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];

}

#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _employedbundleModel.result.courses_menu.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
    cell.model = _employedbundleModel.result.courses_menu[indexPath.row];
    cell.priceBackGroudView.hidden = NO;
    return cell;
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return KHomePageCollectionByLessons;
}






#pragma mark --setBottomButtonAboutPay--

- (void)setAddShoppingCartButtonAndNowPayButton {
    self.addShoppingCart = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.addShoppingCart];
    [self.addShoppingCart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width / 2, 50));
    }];
    self.addShoppingCart.backgroundColor = [UIColor xjfStringToColor:@"#f87c47"];
    [self.addShoppingCart setTitle:@"整套加入购物车" forState:UIControlStateNormal];
    self.addShoppingCart.tintColor = [UIColor whiteColor];
    self.addShoppingCart.titleLabel.font = FONT15;
    [self.addShoppingCart
     addTarget:self action:@selector(addShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nowPay = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.nowPay];
    [self.nowPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.mas_equalTo(50);
    }];
    self.nowPay.backgroundColor = [UIColor xjfStringToColor:@"#ea5f5f"];
    self.nowPay.tintColor = [UIColor whiteColor];
    self.nowPay.titleLabel.font = FONT15;
    [self.nowPay addTarget:self action:@selector(nowPay:) forControlEvents:UIControlEventTouchUpInside];    
}

#pragma mark - actions

#pragma mark CollectionView DidSelected

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
    TalkGridModel *model =  self.employedbundleModel.result.courses_menu[indexPath.row];
    lessonPlayerViewController.lesssonID = model.id_;
    lessonPlayerViewController.playTalkGridModel = model;
    lessonPlayerViewController.originalTalkGridModel = model;
    [self.navigationController pushViewController:lessonPlayerViewController animated:YES];

}


#pragma mark addShoppingCart

- (void)addShoppingCart:(UIButton *)sender {
    TalkGridModel *model =  self.employedbundleModel.result;
    [[XJMarket sharedMarket] addShoppingCardByModel:model];
}

#pragma mark nowPay

- (void)nowPay:(UIButton *)sender {
    OrderDetaiViewController *orderDetailPage = [OrderDetaiViewController new];
    orderDetailPage.dataSource = [NSMutableArray arrayWithObject:self.employedbundleModel.result];
    [self.navigationController pushViewController:orderDetailPage animated:YES];
}



@end
