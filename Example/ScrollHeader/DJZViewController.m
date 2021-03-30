//
//  DJZViewController.m
//  ScrollHeader
//
//  Created by 1345726337@qq.com on 03/29/2021.
//  Copyright (c) 2021 1345726337@qq.com. All rights reserved.
//

#import "DJZViewController.h"
#import <DJZScrollHeaderView.h>
#import <Masonry.h>

@interface DJZViewController ()<UITableViewDataSource, UITableViewDelegate, DJZScrollHeaderViewDelegate>

@property (nonatomic, strong) DJZScrollHeaderView *shView;

@end

@implementation DJZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initView];
}

#pragma mark DJZScrollHeaderViewDelegate

- (UIView *)headerView {
    UIView *floatView = [UIView new];
    floatView.backgroundColor = [UIColor redColor];

    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.backgroundColor = [UIColor whiteColor];
    [left setTitle:@"左" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    [floatView addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.bottom.offset(-20);
        make.width.offset(60);
        make.height.offset(24);
        make.top.offset(200);
    }];

    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.backgroundColor = [UIColor whiteColor];
    [right setTitle:@"左" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];
    [floatView addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-100);
        make.width.offset(60);
        make.height.offset(24);
        make.bottom.offset(-20);
        make.top.offset(200);
    }];
    return floatView;
}

- (NSArray<UIScrollView *> *)listViews {
    NSMutableArray *lists = @[].mutableCopy;
    for (NSInteger i = 0; i < 2; i ++) {
        UITableView *tableView = [UITableView new];
        tableView.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        [lists addObject:tableView];
    }
    return lists;
}

- (CGFloat)listViewHeight {
    return self.view.bounds.size.height;
}

- (CGFloat)ceilHeight {
    return 100;
}

#pragma mark tableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark private

- (void)left {
    _shView.selectedIndex = 0;
}

- (void)right {
    _shView.selectedIndex = 1;
}

#pragma mark InitView

- (void)initView {
    _shView = [[DJZScrollHeaderView alloc] initWithDelegate:self];
    [self.view addSubview:_shView];
    [_shView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
