//
//  FivethViewController.m
//  ScrollViews
//
//  Created by 单车 on 2019/5/22.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import "FivethViewController.h"

#import "NewListViewController.h"

#import "TestListOneViewController.h"

#import "TestListTwoViewController.h"

#import "HtmlStringPrepare.h" //html转换工具

#import <WebKit/WebKit.h>

@interface FivethViewController ()
<UIScrollViewDelegate,NewListViewControllerDelegate,WKUIDelegate>

@property (nonatomic, strong) UIScrollView *backgroundScrollView;       // 最底部横向ScrollView
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) WKWebView *wkwebView;

/** 标题按钮数组 */
@property (nonatomic,strong) NSMutableArray *titleBtnMutArr;
/** 选中的按钮 */
@property (nonatomic,strong)UIButton *selectedBtn;

@property (nonatomic, strong) NewListViewController *currentVC; //当前显示的控制器
@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, assign) CGFloat RHeadViewH;

@property (nonatomic, assign) CGFloat RHeadViewImageH;

@end

#define HeadViewH 50

#define SegmentViewH 50

#define HeadViewImageH 0

static CGFloat const btnW = 70;

@implementation FivethViewController

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
//        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight)];

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
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, HeadViewH)];
            view.backgroundColor = [UIColor redColor];
            
//            UIImageView *imageView = [[UIImageView alloc] init];
//            imageView.frame = CGRectMake(0, 0, kScreenWidth, HeadViewImageH);
//            imageView.image = ImageNamed(@"girl");
//            [view addSubview:imageView];
            
            [view addSubview:self.wkwebView];
            
            UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0,  HeadViewImageH, kScreenWidth, 50)];
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
/** webView */
-(WKWebView *)wkwebView{
    if (_wkwebView == nil) {
        /// 创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        /// 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        /// 最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        //    preference.minimumFontSize = 40.0;
        /// 设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        /// 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        /// 这个类主要用来做native与JavaScript的交互管理

        _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, HeadViewImageH) configuration:config];
        _wkwebView.backgroundColor = [UIColor blueColor];
        _wkwebView.scrollView.scrollEnabled = NO;

        // UI代理
        _wkwebView.UIDelegate = self;
    }
    return _wkwebView;
}

/** 读取数据 */
- (void)loadData{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"zixun" ofType:@"plist"];//
    NSDictionary *inforDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"%@",inforDic);
    
    
    NSString *contentStr = inforDic[@"content"];
    
    NSString *newContentStr = inforDic[@"newcontent"];
    
    NSString *nextContent = inforDic[@"nextContent"];
    
    NSString *webContentStr = [HtmlStringPrepare getHtmlContentWithStr:contentStr];

    NSString *webNewContentStr = [HtmlStringPrepare getHtmlContentWithStr:newContentStr];

    NSString *webNextContentStr = [HtmlStringPrepare getHtmlContentWithStr:nextContent];

    
//    //    item.webContent = [HtmlStringPrepare getHtmlContentWithStr:item.content];
//    item.webContent = [HtmlStringPrepare getHtmlContentWithStr:item.newcontent];
    
    //加载读取处理后的数据
    [self.wkwebView loadHTMLString:webNewContentStr baseURL:nil];
    
    //加载读取大量原有的数据
    //    [self.wkwebView loadHTMLString:item.content baseURL:nil];
    
    //加载读取少量原有的数据
    //    [self.wkwebView loadHTMLString:item.newcontent baseURL:nil];
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

    [self addWebViewObserver];

    [self setUpAllTitles];

    [self loadData];
    

    
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
    if (offset<=_RHeadViewImageH && offset>=0) {
        self.headerView.y = -offset + kNavigationHeight;
        
        // 让其他的tableView同步偏移量 遍历子控件中的tablView  然后设置相同偏移量
        for (NewListViewController *vc in self.childViewControllers) {
            if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                vc.tableView.contentOffset = tableView.contentOffset;
            }
        }
    }
    // 头部完全滑出屏幕
    else if(offset>_RHeadViewImageH){ // 悬停
        self.headerView.y = -_RHeadViewImageH + kNavigationHeight;
        //        self.headerView.height =  264;
        
        // 其他偏移量依然小于150的 设置成150
        for (NewListViewController *vc in self.childViewControllers) {
            if (vc.tableView.contentOffset.y < _RHeadViewImageH) {
                vc.tableView.contentOffset = CGPointMake(vc.tableView.contentOffset.x, _RHeadViewImageH);
            }
        }
    }
    // 被下拉状态
    else if (offset < 0){
//        self.headerView.y =  - offset ;
        self.headerView.y =  - offset + kNavigationHeight;

        
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
    
//    self.navigationController.navigationBar.alpha = offset/HeadViewImageH;
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
    if (maxOffsetY <=_RHeadViewImageH) return;
    for (NewListViewController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y < _RHeadViewImageH) {
            vc.tableView.contentOffset = CGPointMake(0, _RHeadViewImageH);
        }
    }
}
- (void)restTheSubViews:(CGFloat)weibViewH{
    //重写headView的frame
    CGRect headVieweFrame = self.headerView.frame;
    headVieweFrame.size.height = weibViewH + SegmentViewH;
    self.headerView.frame = headVieweFrame;
    
    //重写webView的frame
//    CGRect webViewFrame = self.wkwebView.frame;
//    webViewFrame.size.height = weibViewH;
//    self.wkwebView.frame = headVieweFrame;
    
    //重写btnView的frame
    CGRect btnViewFrame = self.btnView.frame;
    btnViewFrame.origin.y = weibViewH;
    self.btnView.frame = btnViewFrame;
    
    for (NewListViewController *vc in self.childViewControllers) {
//        if (vc.tableView.contentOffset.y > maxOffsetY) {
//            maxOffsetY = vc.tableView.contentOffset.y;
//        }
        [vc setTableViewContentInset:(weibViewH + SegmentViewH)];
    }
    
    self.RHeadViewH = weibViewH + SegmentViewH;
    
    self.RHeadViewImageH = weibViewH;
}
#pragma mark ------ < Private Method > ------
#pragma mark
- (void)addWebViewObserver {
    [self.wkwebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark ------ < KVO > ------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    /**  < 法2 >  */
    /**  < loading：防止滚动一直刷新，出现闪屏 >  */
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect webFrame = self.wkwebView.frame;
        webFrame.size.height = self.wkwebView.scrollView.contentSize.height;
//
//        NSLog(@"网页的高度%f",webFrame.size.height);
        self.wkwebView.frame = webFrame;
        
        self.wkwebView.scrollView.frame = self.wkwebView.bounds;
        
        
        CGFloat webViewContentH = self.wkwebView.scrollView.contentSize.height;
        
        
        [self restTheSubViews:webViewContentH];
    }
}
- (void)removeWebViewObserver {
    [self.wkwebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
- (void)dealloc{
    [self removeWebViewObserver];
}

@end
