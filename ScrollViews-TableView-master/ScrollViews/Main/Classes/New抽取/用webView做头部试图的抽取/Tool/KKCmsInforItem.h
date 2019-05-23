//
//  KKCmsInforItem.h
//  KKTribe
//
//  Created by 单车 on 2018/8/23.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface KKCmsInforItem : NSObject
//内容
@property(nonatomic,strong)NSString *content;

@property(nonatomic,strong)NSString *newcontent;
//是否删除
@property(nonatomic,assign)BOOL Delete;
//发布时间
@property(nonatomic,strong)NSString *gmtPublish;

@property(nonatomic,strong)NSString *Id;
//是否发布
@property(nonatomic,assign)BOOL published;
//标题
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *webContent;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, assign) BOOL commentOff;

@property (nonatomic, strong) WKWebView *wkwebView;

@end
