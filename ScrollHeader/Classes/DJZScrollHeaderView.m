//
//  DJZScrollHeaderView.m
//  Coder
//
//  Created by 张得军 on 2021/3/29.
//  Copyright © 2021 张得军. All rights reserved.
//

#import "DJZScrollHeaderView.h"
#import <Aspects/Aspects.h>
#import <Masonry/Masonry.h>

#define DJZScreenWidth [UIScreen mainScreen].bounds.size.width

@interface DJZScrollHeaderView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat ceilHeight;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollViewH;
@property (nonatomic, strong) NSArray <UIScrollView *> *lists;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, weak) id <DJZScrollHeaderViewDelegate> delegate;

@end

@implementation DJZScrollHeaderView

- (instancetype)initWithDelegate:(id<DJZScrollHeaderViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _lastIndex = -1;
        [self initView];
    }
    return self;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollViewH) {
        [self resetGesture];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _scrollViewH) {
        [self resetGesture];
    }
}

- (void)listDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _scrollViewH) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat headerY = _headerView.frame.origin.y;
        CGFloat headerH = _headerView.frame.size.height;
        CGFloat maxY = headerH - _ceilHeight;
        headerY -= offsetY;
        if (headerY >= 0) {
            headerY = 0;
        }else if(headerY <= -maxY) {
            headerY = -maxY;
        }
        _headerView.frame = CGRectMake(0, headerY, DJZScreenWidth, _headerView.frame.size.height);
        _scrollViewH.frame = CGRectMake(0, headerY + _headerView.frame.size.height, DJZScreenWidth, _scrollViewH.frame.size.height);
        if (headerY == 0 && offsetY < 0) {
            
        }else if (headerY == -maxY && offsetY > 0) {
            
        }else{
            scrollView.contentOffset = CGPointZero;
        }
    }
}

#pragma mark private

- (void)resetGesture {
    NSInteger page = _scrollViewH.contentOffset.x / DJZScreenWidth;
    if (page == _lastIndex) {
        return;
    }
    NSArray *gestures = _scrollView.gestureRecognizers;
    for (NSInteger i = 0; i < gestures.count; i ++) {
        [_scrollView removeGestureRecognizer:gestures[i]];
        if (_lastIndex != -1) {
            [_lists[_lastIndex] addGestureRecognizer:gestures[i]];
        }
    }
    for (UIGestureRecognizer *gesture in _lists[page].gestureRecognizers) {
        [_scrollView addGestureRecognizer:gesture];
    }
    _lastIndex = page;
}

#pragma mark initView

- (void)initView {
    _scrollView = [UIScrollView new];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
    }];
    _ceilHeight = [_delegate ceilHeight];
    _headerView = [_delegate headerView];
    if (_headerView) {
        [_contentView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
        }];
    }
    _lists = [_delegate listViews];
    CGFloat listH = [_delegate listViewHeight];
    if (_lists.count) {
        self.scrollViewH.contentSize = CGSizeMake(DJZScreenWidth * _lists.count, 0);
        [_contentView addSubview:self.scrollViewH];
        [self.scrollViewH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.bottom.offset(0);
            make.height.offset(listH);
        }];
        
        for (NSInteger i = 0; i < _lists.count; i ++) {
            UIScrollView *listView = _lists[i];
            listView.frame = CGRectMake(DJZScreenWidth * i, 0, DJZScreenWidth, listH);
            [self.scrollViewH addSubview:listView];
            NSError *error = nil;
            NSObject *delegate = listView.delegate;
            [delegate aspect_hookSelector:@selector(scrollViewDidScroll:) withOptions:AspectPositionInstead usingBlock:^(id <AspectInfo> aspectInfo) {
                [self listDidScroll:listView];
            } error:&error];
            NSLog(@"");
        }
    }
    [self resetGesture];
}

#pragma mark getter、setter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [_scrollViewH setContentOffset:CGPointMake(DJZScreenWidth * selectedIndex, 0) animated:YES];
}

- (UIScrollView *)scrollViewH {
    if (!_scrollViewH) {
        _scrollViewH = [UIScrollView new];
        _scrollViewH.delegate = self;
        _scrollViewH.bounces = NO;
    }
    return _scrollViewH;
}

@end
