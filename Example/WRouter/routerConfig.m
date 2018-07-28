//
//  routerConfig.m
//  WRouter_Example
//
//  Created by 吴志强 on 2018/7/27.
//  Copyright © 2018年 zzttwzq. All rights reserved.
//

#import "routerConfig.h"
#import <WRouter/WRouter.h>

#import "Wtest.h"
#import "Wpage1.h"

@implementation routerConfig

+ (void) configRouter;
{
    WRouter *router = [WRouter globalRouter];
    [router addHosts:@[@"hmapp",@"hmApp",@"hengmeiApp",@"hengmeiapp"]];
    [router addHostTitles:@[@"www.baidu.com",@"www.apple.com",@"www.api-eh.com",@"www.testapi-eh.com"]];

    [router addRouterFromeDict:@{@"hengmeiApp://www.api-eh.com/Wpage1":@"hengmeiApp://Wpage1"}];
    [router addRouterFromeArray:@[@"hengmeiApp://Wpage1"]];

    [router addRouterFromePlistFile:@"routerInfo.plist"];


    router.unHandledHtmlUrl = ^(NSString * _Nullable urlString) {


    };


    [router addScheme:@"page1" handleBlock:^(id  _Nullable viewController, IDDataBlock  _Nullable dataCallBack) {

        Wtest *test = viewController;
        test.backs = ^(NSString *string) {

            dataCallBack(@{@"data":string});
        };
    }];
}

@end
