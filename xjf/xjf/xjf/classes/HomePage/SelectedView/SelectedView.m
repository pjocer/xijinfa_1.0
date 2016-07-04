//
//  SelectedView.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SelectedView.h"
#import "SelecteButtonView.h"
#import "SelectedTableView.h"
#import "SelectedCollectionView.h"
#import "XJAccountManager.h"

@interface SelectedView ()<SelecteButtonViewDelegate,SelectedTableViewDelegate,SelectedCollectionViewDelegate>
@property (nonatomic, assign) SelectedViewType selectedViewType;
@property (nonatomic, strong) SelecteButtonView *selecteButtonView;
@property (nonatomic, assign) BOOL isSelectedLeftButton;
@property (nonatomic, assign) BOOL isSelectedRightButton;

@property (nonatomic, strong) SelectedTableView *tableView;
@property (nonatomic, strong) SelectedTableView *tableViewRight;
@property (nonatomic, strong) SelectedCollectionView *selectedCollectionView;
@end

@implementation SelectedView

#pragma mark - Public Method

- (instancetype)initWithFrame:(CGRect)frame SelectedViewType:(SelectedViewType)selectedViewType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedViewType = selectedViewType;
        switch (selectedViewType) {
            case ISSchool: {
                [self addSubview:self.selecteButtonView];
                [self addSubview:self.tableView];
                [self addSubview:self.selectedCollectionView];
                
                [self setSubViewsFrame];
                
                self.isSelectedLeftButton = NO;
                self.isSelectedRightButton = NO;
            }
                break;
            case ISEmployed: {
                [self addSubview:self.selecteButtonView];
                [self addSubview:self.tableView];
                [self addSubview:self.testTableView];
                
                [self setSubViewsFrame];
                
                self.isSelectedLeftButton = NO;
                self.isSelectedRightButton = NO;
            }
                break;

            default:
                break;
        }
    }
    return self;
}



#pragma mark - Action

- (void)setSubViewsFrame
{
    _selecteButtonView.frame = CGRectMake(0, 0, self.frame.size.width, 35);
}

- (void)selectedViewHidenOrShow:(SelectedTableView *)selectedTableView
                     IsSelected:(BOOL)isSelected
{
    UIViewController *currentViewController = getCurrentDisplayController();
    if (isSelected) {
        [currentViewController.view bringSubviewToFront:self];
        
        [UIView animateWithDuration:0.5 animations:^{
            selectedTableView.backGroudView.alpha = 0.35;
            selectedTableView.backGroudView.hidden = NO;
            selectedTableView.frame = CGRectMake(0, CGRectGetMaxY(_selecteButtonView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_selecteButtonView.frame));
        }];
       if (selectedTableView == _tableView) _selecteButtonView.leftShowIcon.image = [UIImage imageNamed:@"iconLess"];
        if (selectedTableView == _tableViewRight) _selecteButtonView.rightShowIcon.image = [UIImage imageNamed:@"iconLess"];
    }else{
        [currentViewController.view sendSubviewToBack:self];
        
        [UIView animateWithDuration:0.5 animations:^{
            selectedTableView.backGroudView.alpha = 0.0;
            selectedTableView.backGroudView.hidden = YES;
            selectedTableView.frame = CGRectMake(0, CGRectGetMaxY(_selecteButtonView.frame), self.frame.size.width, 0.01);
        }];
        if (selectedTableView == _tableView) _selecteButtonView.leftShowIcon.image = [UIImage imageNamed:@"iconMore"];
        if (selectedTableView == _tableViewRight) _selecteButtonView.rightShowIcon.image = [UIImage imageNamed:@"iconMore"];
    }
}

- (void)selectedCollectionViewHidenOrShow:(BOOL)isSelected
{
    UIViewController *currentViewController = getCurrentDisplayController();
    if (isSelected) {
        [currentViewController.view bringSubviewToFront:self];
        
        [UIView animateWithDuration:0.5 animations:^{
            _selectedCollectionView.backGroudView.alpha = 0.35;
            _selectedCollectionView.backGroudView.hidden = NO;
            _selectedCollectionView.frame = CGRectMake(0, CGRectGetMaxY(_selecteButtonView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_selecteButtonView.frame));
        }];
       _selecteButtonView.rightShowIcon.image = [UIImage imageNamed:@"iconLess"];
    }else{
        [currentViewController.view sendSubviewToBack:self];
        
        [UIView animateWithDuration:0.5 animations:^{
            _selectedCollectionView.backGroudView.alpha = 0.0;
            _selectedCollectionView.backGroudView.hidden = YES;
            _selectedCollectionView.frame = CGRectMake(0, CGRectGetMaxY(_selecteButtonView.frame), self.frame.size.width, 0.01);
        }];
        _selecteButtonView.rightShowIcon.image = [UIImage imageNamed:@"iconMore"];
    }
}


#pragma mark selecteButtonView Button Action

- (void)selecteButtonView:(SelecteButtonView *)selecteButtonView didButtonByButtonType:(SelecteButtonType)type
{
    if (type == LeftButton) {
        if (_isSelectedRightButton) {
            self.isSelectedRightButton = !_isSelectedRightButton;
        }
        self.isSelectedLeftButton = !_isSelectedLeftButton;
    }else if (type == RightButton){
        if (_isSelectedLeftButton) {
            self.isSelectedLeftButton = !_isSelectedLeftButton;
        }
        self.isSelectedRightButton = !_isSelectedRightButton;
    }
}

#pragma mark selectedTableView didSelectRowAtIndexPath
- (void)selectedTableView:(SelectedTableView *)selectedTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath DataSource:(NSMutableArray *)dataSource
{
    _handlerData(@"this is data");
    if (_isSelectedLeftButton) {
      self.isSelectedLeftButton = NO; _selecteButtonView.leftButtonLabelName.text = [dataSource objectAtIndex:indexPath.row];
    }else if (_isSelectedRightButton) {
     self.isSelectedRightButton = NO; _selecteButtonView.rightButtonLabelName.text = [dataSource objectAtIndex:indexPath.row];
    }
}

- (void)selectedCollectionView:(SelectedCollectionView *)selectedCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath DataSource:(NSMutableArray *)dataSource
{
    _handlerData(@"this is data");
    if (_isSelectedRightButton) {
        self.isSelectedRightButton = NO; _selecteButtonView.rightButtonLabelName.text = [dataSource objectAtIndex:indexPath.row];
    }
}

#pragma mark - setter

- (void)setIsSelectedLeftButton:(BOOL)isSelectedLeftButton
{
    _isSelectedLeftButton = isSelectedLeftButton;
    
    [self selectedViewHidenOrShow:_tableView IsSelected:isSelectedLeftButton];
    
}

- (void)setIsSelectedRightButton:(BOOL)isSelectedRightButton
{
    if (_selectedViewType == ISSchool) {
        _isSelectedRightButton = isSelectedRightButton;
         [self selectedCollectionViewHidenOrShow:isSelectedRightButton];
    }else if (_selectedViewType == ISEmployed){
        _isSelectedRightButton = isSelectedRightButton;
        [self selectedViewHidenOrShow:_tableViewRight IsSelected:isSelectedRightButton];
    }
}

- (void)setLeftButtonName:(NSString *)leftButtonName
{
    if (leftButtonName) {
        _leftButtonName = leftButtonName;
    }
    _selecteButtonView.leftButtonLabelName.text = _leftButtonName;
}

- (void)setRightButtonName:(NSString *)rightButtonName
{
    if (rightButtonName) {
        _rightButtonName = rightButtonName;
    }
    _selecteButtonView.rightButtonLabelName.text = _rightButtonName;
}

- (void)setTableDataSource:(NSMutableArray<NSString *> *)tableDataSource
{
    if (tableDataSource) {
        _tableDataSource = tableDataSource;
    }
    _tableView.dataSource = _tableDataSource;
}

- (void)setTestTableDataSource:(NSMutableArray<NSString *> *)testTableDataSource
{
    if (testTableDataSource) {
        _testTableDataSource = testTableDataSource;
    }
    if (_selectedViewType == ISEmployed) _tableViewRight.dataSource = _testTableDataSource;
    if (_selectedViewType == ISSchool) _selectedCollectionView.dataSource = _testTableDataSource;
}

#pragma mark - getter

- (SelecteButtonView *)selecteButtonView
{
    if (!_selecteButtonView) {
        self.selecteButtonView = [[[NSBundle mainBundle] loadNibNamed:@"SelecteButtonView" owner:self options:nil] lastObject];
        _selecteButtonView.delegate = self;
    }
    return _selecteButtonView;
}

- (SelectedTableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[SelectedTableView alloc] initWithFrame:CGRectNull];
        _tableView.delegate = self;
        @weakify(self)
        _tableView.selectedTableViewFrameUnShow = ^(){
            @strongify(self)
           self.isSelectedLeftButton = !self.isSelectedLeftButton;
        };
    }
    return _tableView;
}

- (SelectedTableView *)testTableView
{
    if (!_tableViewRight) {
        self.tableViewRight = [[SelectedTableView alloc] initWithFrame:CGRectNull];
        _tableViewRight.delegate = self;
        @weakify(self)
        _tableViewRight.selectedTableViewFrameUnShow = ^(){
            @strongify(self)
            self.isSelectedRightButton = !self.isSelectedRightButton;
        };
    }
    return _tableViewRight;
}

- (SelectedCollectionView *)selectedCollectionView
{
    if (!_selectedCollectionView) {
        self.selectedCollectionView = [[SelectedCollectionView alloc] initWithFrame:CGRectNull];
        _selectedCollectionView.delegate = self;
        @weakify(self)
        _selectedCollectionView.selectedTableViewFrameUnShow = ^(){
            @strongify(self)
            self.isSelectedRightButton = !self.isSelectedRightButton;
        };
    }
    return _selectedCollectionView;
}

@end
