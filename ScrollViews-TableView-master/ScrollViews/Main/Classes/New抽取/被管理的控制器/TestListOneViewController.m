//
//  TestListOneViewController.m
//  ScrollViews
//
//  Created by 单车 on 2019/5/8.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import "TestListOneViewController.h"

@interface TestListOneViewController ()

@end

@implementation TestListOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refresh:self.tableView];
}
//下拉刷新数据
- (void)refresh:(UITableView *)tablView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tablView.scrollEnabled = YES;
        NSArray *array = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13];
//        self.dataMutArr = [NSMutableArray arrayWithArray:array];
        self.dataMutArr = [NSMutableArray arrayWithArray:array];
//        [self.dataMutArr addObjectsFromArray:array];
        [self.tableView reloadData];
        [tablView.mj_header endRefreshing];
    });
}
//上啦加载数据
- (void)loadMore:(UITableView *)tablView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
        [self.dataMutArr addObjectsFromArray:array];
        [self.tableView reloadData];
        [tablView.mj_footer endRefreshing];
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"testListOne %ld",indexPath.row];
    return cell;
}
@end
