//
//  CitySelecter.m
//  xjf
//
//  Created by PerryJ on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CitySelector.h"
#import "NSString+FirstLetter.h"
#import <objc/runtime.h>

@interface CitySelector () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CitySelector
- (instancetype)initWithDataSource:(NSMutableArray *)dataSource {
    if (self = [super init]) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - HEADHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    self.tableView.sectionIndexColor = NormalColor;
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    self.sectionTitles = [NSMutableArray arrayWithArray:[self getSectionTitles]];
    [self sortCities];
}

- (NSArray *)getSectionTitles {
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in self.dataSource) {
        NSString *first = [[dic objectForKey:@"areaName"] substringWithRange:NSMakeRange(0, 1)];
        NSString *single = nil;
        if ([first isEqualToString:@"重"]) {
            single = @"C";
        }else {
            single = [first firstLetter];
        }
        if (![titles containsObject:single]) {
            [titles addObject:single];
        }
    }
    [titles sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return titles;
}

- (void)sortCities {
    NSMutableArray *cities = [NSMutableArray array];
    for (NSDictionary *dic in self.dataSource) {
        [cities addObject:[dic objectForKey:@"areaName"]];
    }
    NSMutableDictionary *citiesFirstLetters = [NSMutableDictionary dictionary];
    NSMutableArray *firstLetters = [NSMutableArray array];
    int key = 0;
    for (NSString *city in cities) {
        NSString *firstLetter = @"";
        for (int i = 0; i < city.length; i++) {
            NSString *singleFirstLetter = [[NSString stringWithFormat:@"%@", [city substringWithRange:NSMakeRange(i, 1)]] firstLetter];
            firstLetter = [firstLetter stringByAppendingString:singleFirstLetter];
        }
        if ([firstLetter isEqualToString:@"ZQ"]) {
            firstLetter = @"CQ";
        }
        if ([citiesFirstLetters.allKeys containsObject:firstLetter]) {
            firstLetter = [NSString stringWithFormat:@"%@%d", firstLetter, key];
            [citiesFirstLetters setObject:city forKey:firstLetter];
            key++;
        } else {
            key = 0;
            [citiesFirstLetters setObject:city forKey:firstLetter];
        }
        [firstLetters addObject:firstLetter];
    }
    [firstLetters sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *separate = [NSMutableArray array];
    if (firstLetters.count > 1) {                                                            
        for (NSInteger i = 0; i < firstLetters.count - 1; i++) {
            NSString *first = [firstLetters[i] substringWithRange:NSMakeRange(0, 1)];
            NSString *second = [firstLetters[i + 1] substringWithRange:NSMakeRange(0, 1)];
            if (![first isEqualToString:second]) {
                //count 标识当前sameFirst的下标
                int count = 0;
                for (NSArray *array in separate) {
                    count += array.count;
                }
                NSMutableArray *sameFirst = [NSMutableArray array];
                //key 解决河南，湖南，海南等首字母相同的问题
                int key = 0;
                for (NSInteger j = count; j < i + 1; j++) {
                    NSString *cityName = [citiesFirstLetters objectForKey:firstLetters[j]];
                    if ([sameFirst containsObject:cityName]) {
                        cityName = [citiesFirstLetters objectForKey:[NSString stringWithFormat:@"%@%d", firstLetters[j], key]];
                        key++;
                    } else {
                        key = 0;
                    }
                    [sameFirst addObject:cityName];
                }
                [separate addObject:sameFirst];
                if (i == firstLetters.count - 2) {
                    [separate addObject:@[[citiesFirstLetters objectForKey:firstLetters[i+1]]]];
                }
            }
        }
    } else {
        [separate addObject:@[[citiesFirstLetters objectForKey:firstLetters[0]]]];
    }
    objc_setAssociatedObject(self.dataSource, @"separate", separate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [objc_getAssociatedObject(self.dataSource, @"separate") count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[objc_getAssociatedObject(self.dataSource, @"separate") objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    UIView *biaotiView = [[UIView alloc] init];
    biaotiView.backgroundColor = BackgroundColor;
    biaotiView.frame = CGRectMake(0, 0, SCREENWITH, 30);
    [headView addSubview:biaotiView];
    UILabel *lblBiaoti = [[UILabel alloc] init];
    lblBiaoti.backgroundColor = [UIColor clearColor];
    lblBiaoti.textAlignment = NSTextAlignmentLeft;
    lblBiaoti.font = [UIFont systemFontOfSize:15];
    lblBiaoti.textColor = NormalColor;
    lblBiaoti.frame = CGRectMake(15, 7.5, 200, 15);
    lblBiaoti.text = [self.sectionTitles objectAtIndex:section];
    [biaotiView addSubview:lblBiaoti];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"A"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"A"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = objc_getAssociatedObject(self.dataSource, @"separate")[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = objc_getAssociatedObject(self.dataSource, @"separate")[indexPath.section][indexPath.row];
    NSMutableArray *nextDataSource = nil;
    for (NSDictionary *dic in self.dataSource) {
        if ([[dic objectForKey:@"areaName"] isEqualToString:text]) {
            nextDataSource = [dic objectForKey:@"cities"];
        }
    }
    CitySelector *next = [[CitySelector alloc] initWithDataSource:nextDataSource];
    if ([self.nav_title isEqualToString:@"选择省份"]) {
        next.nav_title = @"选择市";
    } else if ([self.nav_title isEqualToString:@"选择市"]) {
        next.nav_title = @"选择区/县";
    }
    if (self.cityChoosed) {
        next.cityChoosed = [NSString stringWithFormat:@"%@,%@", self.cityChoosed, text];
    } else {
        next.cityChoosed = text;
    }
    next.delegate = self.delegate;
    if ([self.nav_title isEqualToString:@"选择区/县"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cityDidChoosed:)]) {
            [self.delegate cityDidChoosed:next.cityChoosed];
        }
        UIViewController *controller = [self.navigationController.childViewControllers objectAtIndex:1];
        [self.navigationController popToViewController:controller animated:YES];
        return;
    }
    [self.navigationController pushViewController:next animated:YES];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.sectionTitles.count < 5) {
        return nil;
    }
    return self.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
