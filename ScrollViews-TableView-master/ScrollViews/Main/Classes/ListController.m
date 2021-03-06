//
//  ListController.m
//  ScrollViews
//
//  Created by 李刚 on 2017/6/30.
//  Copyright © 2017年 Mr.Lee. All rights reserved.
//

#import "ListController.h"


@interface ListController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    // 占位View
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 264)];
    self.tableView.tableHeaderView = headerView;
    
//    [self setupRefresh];
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
    cell.textLabel.text = [NSString stringWithFormat:@"闲来无事卖个萌 %ld",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
