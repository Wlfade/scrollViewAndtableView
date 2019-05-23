//
//  KKCmsInforItem.m
//  KKTribe
//
//  Created by 单车 on 2018/8/23.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "KKCmsInforItem.h"

@implementation KKCmsInforItem


+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"Id":@"id",
             @"Delete":@"delete",
             };
}
@end
