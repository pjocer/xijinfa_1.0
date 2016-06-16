//
//  CitySelecter.m
//  xjf
//
//  Created by PerryJ on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CitySelecter.h"
#import "pinyin.h"
@interface CitySelecter ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CitySelecter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-HEADHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexColor = NormalColor;
    [self.view addSubview:self.tableView];
}
- (void)initDataSource {
    self.dataSource = [NSMutableArray array];
    NSData *citiesData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zh_CN" ofType:@"json"]];
    self.dataSource = [NSJSONSerialization JSONObjectWithData:citiesData options:NSJSONReadingMutableLeaves error:nil];
    [self sortCities];
}
- (NSArray *)getSectionTitles {
    NSMutableArray *titles = [NSMutableArray array];
    for (char c = 'A'; c <= 'Z'; c++) {
        NSString *charactor=[NSString stringWithFormat:@"%c",c];
        if (![charactor isEqualToString:@"I"]&&![charactor isEqualToString:@"O"]&&![charactor isEqualToString:@"U"]&&![charactor isEqualToString:@"V"]) {
             [titles addObject:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return titles;
}
- (void)sortCities {
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getSectionTitles].count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    UIView *biaotiView = [[UIView alloc]init];
    biaotiView.backgroundColor = BackgroundColor;
    biaotiView.frame=CGRectMake(0, 0, SCREENWITH, 30);
    [headView addSubview:biaotiView];
    UILabel *lblBiaoti = [[UILabel alloc]init];
    lblBiaoti.backgroundColor = [UIColor clearColor];
    lblBiaoti.textAlignment = NSTextAlignmentLeft;
    lblBiaoti.font = [UIFont systemFontOfSize:15];
    lblBiaoti.textColor = [UIColor blackColor];
    lblBiaoti.frame = CGRectMake(15, 7.5, 200, 15);
    lblBiaoti.text = [[self getSectionTitles] objectAtIndex:section];
    [biaotiView addSubview:lblBiaoti];
    return headView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"A"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"A"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld区，第%ld列",indexPath.section,indexPath.row];
    return cell;
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self getSectionTitles];
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog(@"%@,%ld",title,index);
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
