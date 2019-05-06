//
//  NextViewController.m
//  ScrollViews
//
//  Created by 单车 on 2019/5/5.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import "NextViewController.h"
#import "ListController.h" //子控制器

@interface NextViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;                       // 盖在tableView上面的头部, 假装是tableView的headerView

@property (nonatomic, strong) UIScrollView *backgroundScrollView;       // 最底部横向ScrollView


@property (nonatomic, strong) ListController *currentVC; //当前显示的控制器

@property (nonatomic, strong) UIButton *navigationBar;
@end

//214 是 headView 的高度 264 减去 按钮的高度 50
@implementation NextViewController

/** 底部滑动视图 */
-(UIScrollView *)backgroundScrollView{
    if (_backgroundScrollView == nil) {
        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight)];
        if (@available(iOS 11.0, *)) {
            _backgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
            _backgroundScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _backgroundScrollView.scrollIndicatorInsets = _backgroundScrollView.contentInset;
            
        } else {
            // Fallback on earlier versions
        }
        _backgroundScrollView.backgroundColor = [UIColor yellowColor];
        _backgroundScrollView.delegate = self;
        _backgroundScrollView.pagingEnabled = YES;
        _backgroundScrollView.bounces = NO;
        _backgroundScrollView.showsVerticalScrollIndicator = NO;
        _backgroundScrollView.showsHorizontalScrollIndicator = NO;
        _backgroundScrollView.contentSize = CGSizeMake(kScreenWidth*2, self.backgroundScrollView.height);
    }
    return _backgroundScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;

    [self.view addSubview:self.backgroundScrollView];
    
    self.headerView = [self getHeaderView];
    
    //平移手势识别器
    [self.headerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerPan:)]];
    
    
    ListController *list1 = [[ListController alloc] init];
    ListController *list2 = [[ListController alloc] init];
    list1.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight - 100);
    list2.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavigationHeight - 100);
    [self.backgroundScrollView addSubview:list1.view];
    [self.backgroundScrollView addSubview:list2.view];
    [self addChildViewController:list1];
    [self addChildViewController:list2];
    
    [self.view addSubview:self.backgroundScrollView];
    [self.view addSubview:self.headerView];
    
    
    self.currentVC = list1;
    
    //addObserver为对象某个属性添加监听
    [list1.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    [list2.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
//    [list1.tableView setTableHeaderView:self.headerView];
//    [list2.tableView setTableHeaderView:self.headerView];
    
    [self setupRefresh:list1.tableView];
    [self setupRefresh:list2.tableView];
}

- (UIView *)getHeaderView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 264)];
    view.backgroundColor = [UIColor redColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ImageNamed(@"girl");
    
    UIButton *left = [[UIButton alloc] init];
    [left setTitle:@"left" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [left setBackgroundColor:kColorWithFloat(0xf5f5f5) forState:UIControlStateNormal];
    [left addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *right = [[UIButton alloc] init];
    [right setTitle:@"right" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right setBackgroundColor:kColorWithFloat(0xf5f5f5) forState:UIControlStateNormal];
    [right addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, 18, 1, 14)];
    line.backgroundColor = [UIColor blackColor];
    
    [view addSubview:imageView];
    [view addSubview:left];
    [view addSubview:right];
    [view addSubview:line];
    
    // 用约束实现下拉放大效果
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(view);
//        make.height.mas_equalTo(214);
        
        make.left.right.equalTo(view);
        make.height.mas_equalTo(214);
        make.bottom.equalTo(view).offset(-50);
    }];
    
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50));
    }];
    
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(left);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    return view;
}

// 只要监听的属性一改变，就会调用观察者的这个方法，通知你有新值变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    //取出滑动的偏移量 让 所有的自控制器中的tableView 都设置相同的偏移量
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        UITableView *tableView = object;
        
        //        if ([self.currentVC isRefreshing]) {
        //            return;
        //        }
        
        // 头部显示一半或全部
        if (offset<=214 && offset>=0) {
            self.headerView.y = -offset;
            self.headerView.height =  264;
            
            // 让其他的tableView同步偏移量 遍历子控件中的tablView  然后设置相同偏移量
            for (ListController *vc in self.childViewControllers) {
                if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                    vc.tableView.contentOffset = tableView.contentOffset;
                }
            }
        }
        // 头部完全滑出屏幕
        else if(offset>214){ // 悬停
            self.headerView.y = -214;
            self.headerView.height =  264;
            
            // 其他偏移量依然小于150的 设置成150
            for (ListController *vc in self.childViewControllers) {
                if (vc.tableView.contentOffset.y < 214) {
                    vc.tableView.contentOffset = CGPointMake(vc.tableView.contentOffset.x, 214);
                }
            }
        }
        // 被下拉状态
        else if (offset<0){
//            self.headerView.y = 0;
//            self.headerView.height =  264 - offset;
            
            self.headerView.y = - offset;
            self.headerView.height =  264 ;
            
            // 让其他的tableView同步偏移量
            for (ListController *vc in self.childViewControllers) {
                if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                    vc.tableView.contentOffset = tableView.contentOffset;
                }
            }
        }
        
//        self.navigationBar.alpha = offset/214.0;
        NSLog(@"offset:%f",offset);
        self.navigationController.navigationBar.alpha = offset/214.0;
    }
    
}
//这个是加一个拖动的手势 在headView 上 然后可以滑动 底部的 tableView  因为下拉54的距离开始下拉刷新
//当tableView的 contentOffSet发生偏移的时候 KVO 监听
- (void)headerPan:(UIPanGestureRecognizer *)pan{
    // 触点移动的绝对距离
    
    // CGPoint location = [pan locationInView:self.view];
    // 移动两点之间的相对距离
    CGPoint translation = [pan translationInView:self.view];
    UIScrollView *scrollView = self.currentVC.tableView;
    CGFloat offsetY = scrollView.contentOffset.y-translation.y;
    
    // 模仿一下scrollView下拉回弹(0 到 -214) 如果偏移量 > -214 （极限） 则位置发生偏移
    if (offsetY > -214){
        [scrollView setContentOffset:CGPointMake(0, offsetY)];
        NSLog(@"offsetY> -214:%f",offsetY);
    }
    
    if (offsetY > -54) {
//        [scrollView setContentOffset:CGPointMake(0, offsetY)];
        MJRefreshState state = self.currentVC.tableView.mj_header.state;
        NSLog(@"state:%zd",state);
//        [self.currentVC.tableView.mj_header setState:MJRefreshStatePulling];
    }
    //如果是下拉动作 并且 手势动作结束后 偏移量 回 0
//    if (pan.state == UIGestureRecognizerStateEnded && offsetY<0) {
//        [scrollView setContentOffset:CGPointZero animated:YES];
//        NSLog(@"offsetY:%f",offsetY);
//    }
    if (pan.state == UIGestureRecognizerStateEnded && offsetY<-54) {
//        [scrollView setContentOffset:CGPointZero animated:YES];
//        NSLog(@"offsetY:%f",offsetY);
        [self.currentVC.tableView.mj_header beginRefreshing];
    }else if (pan.state == UIGestureRecognizerStateEnded && offsetY<0){
        [scrollView setContentOffset:CGPointZero animated:YES];
        NSLog(@"offsetY:%f",offsetY);
    }
    
    [pan setTranslation:CGPointZero inView:self.view];
}
- (void)changeVC:(UIButton *)button{
    if ([button.currentTitle isEqualToString:@"left"]) {
        [self.backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [self.backgroundScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
    [self adjustOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self adjustOffset];
}

- (void)adjustOffset{
    
    // 计算出最大偏移量(三个tableView里面偏移最大值)
    CGFloat maxOffsetY = 0;
    for (ListController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y > maxOffsetY) {
            maxOffsetY = vc.tableView.contentOffset.y;
        }
    }
    
    // 如果最大偏移量大于150，让没滑到达临界值的,设置到临界值处
    if (maxOffsetY <=214) return;
    for (ListController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y < 214) {
            vc.tableView.contentOffset = CGPointMake(0, 214);
        }
    }
}

#pragma mark TableViewRefresh
-(void)setupRefresh:(UITableView *)tablView
{
    WS(weakSelf)
    tablView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SS(strongSelf)
        [strongSelf refresh:tablView];
    }];
//    [tablView.mj_header beginRefreshing];
    
    MJRefreshAutoStateFooter *foot = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        [strongSelf loadMore:tablView];
        //        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
        //            strongSelf->_paginator.page++;
        //
        //        }else{
        //            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        //        }
    }];
    foot.triggerAutomaticallyRefreshPercent = -10;
    
    tablView.mj_footer = foot;
}
- (void)refresh:(UITableView *)tablView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tablView.mj_header endRefreshing];
    });
    
    
}
- (void)loadMore:(UITableView *)tablView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tablView.mj_footer endRefreshing];
    });
    
}

- (void)dealloc{
//    [list1.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [list2.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
@end
