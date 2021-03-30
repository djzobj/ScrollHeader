//
//  DJZScrollHeaderView.h
//  Coder
//
//  Created by 张得军 on 2021/3/29.
//  Copyright © 2021 张得军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DJZScrollHeaderViewDelegate <NSObject>

//头部视图
- (UIView *)headerView;

/*
 * scrollView.delegate必须实现scrollViewDidScroll
 */
- (NSArray <UIScrollView *>*)listViews;

//吸顶高度
- (CGFloat)ceilHeight;

- (CGFloat)listViewHeight;

@end

@interface DJZScrollHeaderView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithDelegate:(id<DJZScrollHeaderViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
