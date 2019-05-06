//
//  NewListViewController.h
//  ScrollViews
//
//  Created by 单车 on 2019/5/6.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewListViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataMutArr;

/** tablViewHeadView的占位高度 */
@property (nonatomic, assign) CGFloat placeHoldHeight;

/** 视图的frame */
@property(nonatomic,assign)CGRect viewFrame;
@end

NS_ASSUME_NONNULL_END
