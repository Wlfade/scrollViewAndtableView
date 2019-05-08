//
//  NewFourthViewController.m
//  ScrollViews
//
//  Created by 单车 on 2019/5/6.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import "NewFourthViewController.h"

#import "NewListViewController.h"

#import "TestListOneViewController.h"

#import "TestListTwoViewController.h"

@interface NewFourthViewController ()
<UIScrollViewDelegate,NewListViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *backgroundScrollView;       // 最底部横向ScrollView
@property (nonatomic, strong) UIView *headerView;
/** 标题按钮数组 */
@property (nonatomic,strong) NSMutableArray *titleBtnMutArr;
/** 选中的按钮 */
@property (nonatomic,strong)UIButton *selectedBtn;

@property (nonatomic, strong) NewListViewController *currentVC; //当前显示的控制器
@property (nonatomic, strong) UIView *btnView;
@end

#define HeadViewH 264+kNavigationHeight

#define SegmentViewH 50

#define HeadViewImageH 214.0

static CGFloat const btnW = 70;

@implementation NewFourthViewController

#pragma mark - lazy
/** 标题按钮数组 */
- (NSMutableArray *)titleBtnMutArr{
    if (!_titleBtnMutArr) {
        _titleBtnMutArr = [NSMutableArray array];
    }
    return _titleBtnMutArr;
}

/** 底部滑动视图 */
-(UIScrollView *)backgroundScrollView{
    if (_backgroundScrollView == nil) {
        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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

/** headView 头部视图 */
-(UIView *)headerView{
    if (_headerView == nil) {
        UIView *headview = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeadViewH)];
            view.backgroundColor = [UIColor redColor];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(0, kNavigationHeight, kScreenWidth, HeadViewImageH);
            imageView.image = ImageNamed(@"girl");
            [view addSubview:imageView];
            
            UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationHeight + HeadViewImageH, kScreenWidth, 50)];
            btnView.backgroundColor = [UIColor grayColor];
            self.btnView = btnView;
            [view addSubview:btnView];
            
            view;
        });
        _headerView = headview;
        
        //平移手势识别器
        [_headerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerPan:)]];

    }
    return _headerView;
}
//添加对应的自控制器
- (void)addChildViewControllers{
    TestListOneViewController *mainVC = [[TestListOneViewController alloc]init];
    mainVC.delegate = self;
    mainVC.view.backgroundColor = [UIColor redColor];
    mainVC.title = @"关注";

    [mainVC setTableViewContentInset:(HeadViewH)];
    [self addChildViewController:mainVC];
    
    
    TestListTwoViewController *social1 = [[TestListTwoViewController alloc]init];
    social1.delegate = self;
    social1.view.backgroundColor = [UIColor blueColor];
    social1.title = @"热门";

    [social1 setTableViewContentInset:(HeadViewH)];
    [self addChildViewController:social1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    //添加子控制器
    [self addChildViewControllers];
    //加背景scrollView
    [self.view addSubview:self.backgroundScrollView];
    
    [self.view addSubview:self.headerView];
    
    [self setUpAllTitles];
}

#pragma mark 添加标题
- (void)setUpAllTitles{
    //添加所有的标题按钮
    int count = (int)self.childViewControllers.count;
    CGFloat btnX = 10;
    for (int i = 0; i < count; i ++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        titleButton.tag = i;

        UIViewController *vc = self.childViewControllers[i];

        [titleButton setTitle:vc.title forState:UIControlStateNormal];

        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        btnX = btnW * i ;

        titleButton.frame = CGRectMake(btnX, 10, btnW, 30);

        //监听按钮的点击
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.titleBtnMutArr addObject:titleButton];

        [self.btnView addSubview:titleButton];

        if (i == 0) {
            [self titleClick:titleButton];
        }

    }
}
#pragma mark - 按钮的点击
- (void)titleClick:(UIButton *)button{
    //获取对应的 tag值
    NSInteger tag = button.tag;
    //计算水平方向的距离
    CGFloat X = tag * kScreenWidth;
    //3.内容滚动视图滚动到对应的位置
    self.backgroundScrollView.contentOffset = CGPointMake(X, 0);
    
    //获取子控制器
    [self setUpOneViewController:tag];

    //设置按钮的状态
    [self selectedBtn:button];
//
//    //刷新偏移量
    [self adjustOffset];
}
#pragma mark 添加一个子控制器的View到对应的位置上
- (void)setUpOneViewController:(NSInteger )tag{
    
    NewListViewController *childVC = self.childViewControllers[tag];
    
    //判断这个控制器的视图是否已经加载
    //9.0后方法
    //    if (childVC.viewIfLoaded) {
    //        return;
    //    }
    if (childVC.view.superview) {
        return;
    }
    
    CGFloat X = tag * kScreenWidth;
    CGFloat H = self.backgroundScrollView.bounds.size.height;
    
    [childVC resetTheViewFrame:CGRectMake(X, 0, kScreenWidth, H)];
    
    [self.backgroundScrollView addSubview:childVC.view];
    
    self.currentVC = (NewListViewController *)childVC;
}
#pragma mark - 选中标题设置状态变化
- (void)selectedBtn:(UIButton *)sender{
    
    if (_selectedBtn != sender) {
        [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //1.把标题颜色 变成 红色
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        
        sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
        _selectedBtn.transform = CGAffineTransformIdentity;
        
        _selectedBtn = sender;
    }else{
        return;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self adjustOffset];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //字体缩放1.缩放比例
    
    //获取角标
    NSInteger i = scrollView.contentOffset.x / kScreenWidth;
    
    NSInteger leftI = scrollView.contentOffset.x / kScreenWidth;
    
    NSInteger rightI = leftI + 1;
    
    //获取左边的按钮
    UIButton *leftBtn = self.titleBtnMutArr[leftI];
    
    NSInteger count = self.titleBtnMutArr.count;
    
    UIButton *rightBtn ;
    //获取右边的按钮
    if (rightI < count) {
        rightBtn = self.titleBtnMutArr[rightI];
    }
    
    
    //计算缩放比例
    CGFloat scaleR = scrollView.contentOffset.x / kScreenWidth; //右边的缩放比例
    
    scaleR -= leftI;
    
    CGFloat scaleL = 1 - scaleR; //左边的缩放比例
    
    NSLog(@"比例：%f",scaleL);
    //缩放按钮
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL * 0.3 + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * 0.3 + 1, scaleR * 0.3 + 1);
}
//滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前角标
    NSInteger i = scrollView.contentOffset.x / kScreenWidth;
    
    //获取标题按钮
    UIButton *titleBtn = self.titleBtnMutArr[i];
    
    //1.选中标题
    [self selectedBtn:titleBtn];
    
    //2.将对应的view添加上去
    [self setUpOneViewController:i];
}
#pragma mark - 拖拽手势
//这个是加一个拖动的手势 在headView 上 然后可以滑动 底部的 tableView  因为下拉54的距离开始下拉刷新
//当tableView的 contentOffSet发生偏移的时候 KVO 监听
- (void)headerPan:(UIPanGestureRecognizer *)pan{
    // 移动两点之间的相对距离
    CGPoint translation = [pan translationInView:self.view];
    UIScrollView *scrollView = self.currentVC.tableView;
    
    // 触点移动的绝对距离
    CGFloat offsetY = scrollView.contentOffset.y-translation.y;
    
    // 模仿一下scrollView下拉回弹(0 到 -150) 如果偏移量 > -150（极限） 则位置发生偏移
    if (offsetY > -150){
        [scrollView setContentOffset:CGPointMake(0, offsetY)];
    }
    
    if (offsetY < -54) {
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            MJRefreshNormalHeader *headView =(MJRefreshNormalHeader *)self.currentVC.tableView.mj_header;
            headView.arrowView.transform = CGAffineTransformIdentity;
        }];
    }else{
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            MJRefreshNormalHeader *headView =(MJRefreshNormalHeader *)self.currentVC.tableView.mj_header;
            headView.arrowView.transform =CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    }
    
    //如果是下拉动作 并且 手势动作结束后 偏移量 回 0
    if (pan.state == UIGestureRecognizerStateEnded && offsetY<-54) {
        //如果手势的动作状态是结束，同时下拉的偏移量 大于 54时 开始进行刷新动作
        [self.currentVC.tableView.mj_header beginRefreshing];
    }else if (pan.state == UIGestureRecognizerStateEnded && offsetY<0){
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
    
    [pan setTranslation:CGPointZero inView:self.view];
}
#pragma mark - NewListViewControllerDelegate
- (void)NewListViewControllerLinkage:(NewListViewController *)viewController withTheLinkAgetOffsetY:(CGFloat)offsetYY{
    CGFloat offset = offsetYY;
    NSLog(@"偏移：%f",offset); //下拉 ：负数 、上推 ：正数
    UITableView *tableView = viewController.tableView;
    
    //        if ([self.currentVC isRefreshing]) {
    //            return;
    //        }
    
    // 头部显示一半或全部
    if (offset<=HeadViewImageH && offset>=0) {
        self.headerView.y = -offset;

        // 让其他的tableView同步偏移量 遍历子控件中的tablView  然后设置相同偏移量
        for (NewListViewController *vc in self.childViewControllers) {
            if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                vc.tableView.contentOffset = tableView.contentOffset;
            }
        }
    }
    // 头部完全滑出屏幕
    else if(offset>HeadViewImageH){ // 悬停
        self.headerView.y = -HeadViewImageH;
//        self.headerView.height =  264;
        
        // 其他偏移量依然小于150的 设置成150
        for (NewListViewController *vc in self.childViewControllers) {
            if (vc.tableView.contentOffset.y < HeadViewImageH) {
                vc.tableView.contentOffset = CGPointMake(vc.tableView.contentOffset.x, HeadViewImageH);
            }
        }
    }
    // 被下拉状态
    else if (offset<0){
        self.headerView.y =  - offset ;

//        self.headerView.height =  264 ;
        
        // 让其他的tableView同步偏移量
        for (NewListViewController *vc in self.childViewControllers) {
            if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                vc.tableView.contentOffset = tableView.contentOffset;
            }
        }
    }

    MJRefreshState state = self.currentVC.tableView.mj_header.state;
    
//    NSLog(@"offset:%f state:%ld",offset,(long)state);
    
    self.navigationController.navigationBar.alpha = offset/HeadViewImageH;
}

//调整所有子控制器的偏移量
- (void)adjustOffset{
    
    // 计算出最大偏移量(三个tableView里面偏移最大值)
    CGFloat maxOffsetY = 0;
    for (NewListViewController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y > maxOffsetY) {
            maxOffsetY = vc.tableView.contentOffset.y;
        }
    }
    
    // 如果最大偏移量大于150，让没滑到达临界值的,设置到临界值处
    if (maxOffsetY <=214) return;
    for (NewListViewController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y < 214) {
            vc.tableView.contentOffset = CGPointMake(0, 214);
        }
    }
}
@end
