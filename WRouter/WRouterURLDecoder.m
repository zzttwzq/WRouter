//
//  WRouterURLDecoder.m
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import "WRouterURLDecoder.h"

@implementation WRouterURLDecoder

/**
 初始化scheme

 @param scheme 初始化的scheme
 @return 返回decoder实例
 */
- (instancetype) initWithScheme:(NSString *)scheme;
{
    self = [super init];
    if (self) {
        //1.判断是否为空.
        if (scheme.length == 0) {
            [WRouterURLDecoder showDebugLog:@"传入一个空的路由！"];
            return nil;
        }

        //2.判断段路由是否没有含义
        if (![scheme containsString:@"://"]) {
            scheme = [NSString stringWithFormat:@"WRouter://%@",scheme];
        }
        self.fullUrlString = scheme;

        //3.判断url 头 和 其他的信息
        NSArray *array = [scheme componentsSeparatedByString:@"://"];
        self.hostTile = array[0];

        if (array.count > 1) {

            NSString *urlBody = array[1];
            NSArray *mainUrlBodyArray = [urlBody componentsSeparatedByString:@"?"];

            NSString *mainUrl = mainUrlBodyArray[0];
            NSString *paramsString = @"";
            if (mainUrlBodyArray.count > 1) {
                paramsString = mainUrlBodyArray[1];
            }

            NSMutableArray *routerstacks = [NSMutableArray arrayWithArray:[mainUrl componentsSeparatedByString:@"/"]];

            //4.获取host
            self.routerStack = routerstacks;
            self.host = routerstacks[0];
            self.className = [routerstacks lastObject];

            if (routerstacks.count > 0) {
                [routerstacks removeObjectAtIndex:0];
            }
            self.routerStack = routerstacks;

            self.urlString = [NSString stringWithFormat:@"%@://%@",self.hostTile,mainUrlBodyArray[0]];
            self.params = [WRouterURLDecoder getParamsWithString:paramsString];
        }
        else{

            [WRouterURLDecoder showDebugLog:[NSString stringWithFormat:@"路由格式不正确 : %@",scheme]];
        }
    }
    return self;
}


/**
 解析参数字符串成字典

 @param paramsString 要解析的字符串
 @return 返回字典
 */
+ (NSDictionary *) getParamsWithString:(NSString *)paramsString;
{
    if (paramsString.length == 0) {
        return nil;
    }

    NSArray *array1 = [paramsString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *string in array1) {

        NSArray *keyValueArray = [string componentsSeparatedByString:@"="];
        [dict setObject:keyValueArray[1] forKey:keyValueArray[0]];
    }

    return dict;
}


/**
 显示错误消息

 @param log 消息
 */
+ (void) showDebugLog:(NSString *)log;
{
    #ifdef DEBUG
        NSLog(@"< WRouter >%@",log);
    #endif
}

@end
