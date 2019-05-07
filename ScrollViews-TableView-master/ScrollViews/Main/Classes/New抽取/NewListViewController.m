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
@property (nonatomic, assign) <#Class#> <#property#>;
@end

@implementation NewListViewController
//- (void)viewDidLoad {
//    [super viewDidLoad];
//}
- (void)resetTheViewFrame:(CGRect)viewFrame{
    self.viewFrame = viewFrame;
    
    self.view.frame = viewFrame;
    
    self.tableView.frame = self.view.bounds;
}
//重新设置控件的frame
//- (void)setViewFrame:(CGRect)viewFrame{
//    _viewFrame = viewFrame;
//    self.view.frame = viewFrame;
//
//    self.tableView.frame = self.view.bounds;
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    //addObserver为对象某个属性添加监听
    /*
     reason: '<NewListViewController: 0x7fa2d6d08240>: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.
     Key path: contentOffset
     Observed object: <UITableView: 0x7fa2d8010e00; frame = (0 0; 414 896); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x600000bc7870>; layer = <CALayer: 0x6000005b7c80>; contentOffset: {0, 0}; contentSize: {0, 0}; adjustedContentInset: {0, 0, 0, 0}>
     Change: {
     kind = 1,
     new = NSPoint: {0, 0}
     }
     */
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

//    [social1.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];


}
- (void)setPlaceHoldHeight:(CGFloat)placeHoldHeight{
    _placeHoldHeight = placeHoldHeight;
    // 占位View
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, placeHoldHeight)];
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];

    }
    cell.textLabel.text = [NSString stringWithFormat:@"new闲来无事卖个萌 %ld",indexPath.row];
    return cell;
}

@end
