//
//  HtmlStringPrepare.m
//  JCZJ
//
//  Created by apple on 17/1/13.
//  Copyright © 2017年 apple. All rights reserved.
//
//#import "RequestGroup.h"
#import "HtmlStringPrepare.h"

@implementation HtmlStringPrepare

+ (NSString *)getHtmlContentWithStr:(NSString *)htmlStr{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"wenzhang" ofType:@"htm"];//
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"replaceHtml" withString:htmlStr];
    
//    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"request_wenzhang" withString:[RequestGroup get_request_wenzhang]];

    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"request_wenzhang" withString:@"http://api.jczj123.com"];

//    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"requestImage_wenzhang" withString:[RequestGroup get_requestImage_wenzhang]];

    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"requestImage_wenzhang" withString:@"http://img-api.jczj123.com"];


//    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"requestBt_wenzhang" withString:[RequestGroup get_request_wenzhang]];

    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"requestBt_wenzhang" withString:@"http://api.jczj123.com"];

//    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"requestFt_wenzhang" withString:[RequestGroup get_request_wenzhang]];

    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"requestFt_wenzhang" withString:@"http://api.jczj123.com"];

    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"ftRaceBackGroundPath" withString:[NSString stringWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:@"ftRaceBackGround.png" ofType:nil]]];
    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"btRaceBackGroundPath" withString:[NSString stringWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:@"btRaceBackGround.png" ofType:nil]]];
    
//    if ([UserStateManager shareInstance].authedUserId) {
//        htmlString=[htmlString stringByReplacingOccurrencesOfString:@"replaceUserId" withString:[UserStateManager shareInstance].authedUserId];
//    }

    return htmlString;
    
}

@end
