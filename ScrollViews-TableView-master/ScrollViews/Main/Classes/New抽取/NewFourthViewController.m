//
//  NewFourthViewController.m
//  ScrollViews
//
//  Created by 单车 on 2019/5/6.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import "NewFourthViewController.h"
#import "NewListViewController.h"


@interface NewFourthViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *backgroundScrollView;       // 最底部横向ScrollView
@property (nonatomic, strong) UIView *headerView;
/** 标题按钮数组 */
@property (nonatomic,strong) NSMutableArray *titleBtnMutArr;
/** 选中的按钮 */
@property (nonatomic,strong)UIButton *selectedBtn;

@property (nonatomic, strong) NewListViewController *currentVC; //当前显示的控制器

@end

static CGFloat const btnW = 70;

@implementation NewFourthViewController

#pragma mark - lazy
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
//添加对应的自控制器
- (void)addChildViewControllers{
    NewListViewController *mainVC = [[NewListViewController alloc]init];
    mainVC.view.backgroundColor = [UIColor redColor];
    mainVC.title = @"关注";
    //控制器必须先设置了frame 才可以加KVO 设置 否则失效 改下
    //    mainVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight - 100);
    [self addChildViewController:mainVC];
    
    
    NewListViewController *social1 = [[NewListViewController alloc]init];
    social1.view.backgroundColor = [UIColor blueColor];
    social1.title = @"热门";
    //    social1.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight - 100);
    [self addChildViewController:social1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控制器
    [self addChildViewControllers];
    //加背景scrollView
    [self.view addSubview:self.backgroundScrollView];
    
    UIView *headview = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, 264)];
        view.backgroundColor = [UIColor redColor];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, kScreenWidth, 214);
        imageView.image = ImageNamed(@"girl");
        [view addSubview:imageView];
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 214, kScreenWidth, 50)];
        btnView.backgroundColor = [UIColor grayColor];
        [view addSubview:btnView];
        
        CGFloat btnX = 10;
        for (int i = 0; i < 2; i ++) {
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
            titleButton.tag = i;
            
            UIViewController *vc = self.childViewControllers[i];

            [titleButton setTitle:vc.title forState:UIControlStateNormal];
            
//            [titleButton setTitle:[NSString stringWithFormat:@"标题%d",i] forState:UIControlStateNormal];
            
            [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            btnX = btnW * i ;
            
            titleButton.frame = CGRectMake(btnX, 10, btnW, 30);
            
            //监听按钮的点击
            [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.titleBtnMutArr addObject:titleButton];
            
            [btnView addSubview:titleButton];
            
            if (i == 0) {
                [self titleClick:titleButton];
            }
            
        }
        view;
    });
    self.headerView = headview;
    [self.view addSubview:headview];
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
//    [self adjustOffset];
    
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
//    childVC.view.frame = CGRectMake(X, 0, kScreenWidth, H);
    
    
    childVC.viewFrame = CGRectMake(X, 0, kScreenWidth, H);
    
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
//    [self adjustOffset];
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
    
    //颜色的设置
    //    UIColor *rightColor = [UIColor colorWithRed:scaleR * 0.48 + 0.2 green:scaleR * 0.48 + 0.2 blue:scaleR * 0.48 + 0.2 alpha:1];
    //
    //    UIColor *leftColor = [UIColor colorWithRed:scaleL * 0.48 + 0.2 green:scaleL * 0.48 + 0.2 blue:scaleL * 0.48 + 0.2 alpha:1];
    
    
    //    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    //startTimerAndScan//    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    
    //    [self setTitleCenterWithIndex:i];
    
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
@end
