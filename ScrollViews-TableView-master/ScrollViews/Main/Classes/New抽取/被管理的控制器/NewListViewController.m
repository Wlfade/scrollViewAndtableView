//
//  NewListViewController.m
//  ScrollViews
//
//  Created by 单车 on 2019/5/6.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import "NewListViewController.h"

@interface NewListViewController ()
<UITableViewDelegate,UITableViewDataSource>


/** 视图的frame */
@property(nonatomic,assign)CGRect viewFrame;

/** 是否已经设置了KVO */
@property (nonatomic, assign) BOOL isSetKVO;
@end

@implementation NewListViewController

/** dataMutArr */
-(NSMutableArray *)dataMutArr{
    if (_dataMutArr == nil) {
        _dataMutArr = [NSMutableArray array];
    }
    return _dataMutArr;
}

- (void)resetTheViewFrame:(CGRect)viewFrame{
    self.viewFrame = viewFrame;
    
    self.view.frame = viewFrame;
    
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];
    
    self.tableView = [[UITableView alloc]init];
    //必须在设置默认的tablView时设置一个默认的frame 不然在加载出新的tablView时偏移有问题
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    self.tableView.backgroundColor = [UIColor cyanColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    //addObserver为对象某个属性添加监听 监听的前提是这个值要有 所以提前设置tableView的frame

//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];


    [self setupRefresh:self.tableView];
}
#pragma mark - 设置占位高度视图
- (void)setTableViewContentInset:(CGFloat)contentInset{
//    [self.tableView setContentInset:UIEdgeInsetsMake(contentInset, 0, 0, 0)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentInset)];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark TableViewRefresh
-(void)setupRefresh:(UITableView *)tablView
{
    WS(weakSelf)
    tablView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SS(strongSelf)
        tablView.scrollEnabled = NO;
        [strongSelf refresh:tablView];
    }];
    //    [tablView.mj_header beginRefreshing];
    
    MJRefreshAutoStateFooter *foot = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
//        tablView.scrollEnabled = NO;
        [strongSelf loadMore:tablView];
    }];
    foot.triggerAutomaticallyRefreshPercent = -10;
    
    tablView.mj_footer = foot;
}
- (void)refresh:(UITableView *)tablView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tablView.scrollEnabled = YES;
        [tablView.mj_header endRefreshing];
    });
}
- (void)loadMore:(UITableView *)tablView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        tablView.scrollEnabled = YES;
        [tablView.mj_footer endRefreshing];
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.tableView) {
        [self getTableViewOffsetY:self.tableView];
    }
}
- (void)getTableViewOffsetY:(UITableView *)tableView{
    CGFloat offsetY = tableView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(NewListViewControllerLinkage:withTheLinkAgetOffsetY:)]) {
        [self.delegate NewListViewControllerLinkage:self withTheLinkAgetOffsetY:offsetY];
    }
}

@end
