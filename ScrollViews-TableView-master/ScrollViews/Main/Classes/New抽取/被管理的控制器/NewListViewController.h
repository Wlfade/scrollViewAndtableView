//
//  NewListViewController.h
//  ScrollViews
//
//  Created by 单车 on 2019/5/6.
//  Copyright © 2019 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NewListViewController;
@protocol NewListViewControllerDelegate <NSObject>

@optional
- (void)NewListViewControllerLinkage:(NewListViewController *)viewController withTheLinkAgetOffsetY:(CGFloat)offsetYY;

@end

@interface NewListViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataMutArr;

/** 代理 */
@property(nonatomic,weak)id <NewListViewControllerDelegate> delegate;
///** 视图的frame */
//@property(nonatomic,assign)CGRect viewFrame;

///** 赋值完成的block */
//@property(nonatomic,strong) void(^testBlock)(void);


/**
 重新设置视图的frame

 @param viewFrame frame
 */
- (void)resetTheViewFrame:(CGRect)viewFrame;


/**
 设置偏移量占位视图

 @param contentInset 视图的高度
 */
- (void)setTableViewContentInset:(CGFloat)contentInset;
@end

NS_ASSUME_NONNULL_END
