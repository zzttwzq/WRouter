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


    router.handledHtmlUrl = ^(NSString * _Nullable urlString) {


    };

    //自定义的解析规则，适应自己的需要
    router.custmDecodeHandler = ^(WRouterURLDecoder * _Nullable decoder) {

        WRouterURLDecoder *newDecoder = [[WRouter globalRouter] decoderWithScheme:decoder.params[@"routerpath"]];

        decoder.className = newDecoder.className;
        decoder.routerType = newDecoder.routerType;
        decoder.urlString = newDecoder.urlString;
    };
}

@end
