//
//  WRouterEntry.m
//  美丽吧
//
//  Created by 吴志强 on 2018/6/26.
//  Copyright © 2018年 吴志强. All rights reserved.
//

#import "WRouterEntry.h"

@implementation WRouterEntry


/**
 初始化方法

 @param urlString url字符串
 @return 返回实例
 */
- (instancetype) initWithUrlString:(NSString *)urlString;
{
    self = [super init];
    if (self) {

        if ([urlString containsString:@"WRouter"]) {

            urlString = [NSString stringWithFormat:@"WRouter://%@",urlString];
        }

        self.fullUrlString = urlString;

        NSArray *array = [urlString componentsSeparatedByString:@"://"];
        self.schemeTitle = array[0];

        NSLog(@"<WRouter> 无效的URL:%@",urlString);

        if (array.count > 1) {

            NSString *urlBody = array[1];
            NSArray *mainUrlBodyArray = [urlBody componentsSeparatedByString:@"?"];

            NSString *mainUrl = mainUrlBodyArray[0];
            NSString *paramsString = @"";
            if (mainUrlBodyArray.count > 1) {
                paramsString = mainUrlBodyArray[1];
            }

            NSArray *bodyArray = [mainUrl componentsSeparatedByString:@"/"];


            self.host = bodyArray[0];
            self.className = [bodyArray lastObject];
            self.urlString = [NSString stringWithFormat:@"%@://%@",self.schemeTitle,mainUrlBodyArray[0]];
            self.params = [WRouterEntry getParamsWithString:paramsString];
        }
    }
    return self;
}


/**
 获取参数字典

 @param paramString 参数字符串
 @return 返回参数字典
 */
+ (NSDictionary *)getParamsWithString:(NSString *)paramString;
{
    if (paramString.length == 0) {
        return nil;
    }

    NSArray *array1 = [paramString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *string in array1) {

        NSArray *keyValueArray = [string componentsSeparatedByString:@"="];
        [dict setObject:keyValueArray[1] forKey:keyValueArray[0]];
    }

    return dict;
}


/**
 设置参数字典

 @param params 参数字典
 */
-(void)setParams:(NSDictionary *)params
{
    _params = params;

    NSArray *urlBodyArray = [_fullUrlString componentsSeparatedByString:@"?"];

    NSString *paramstring = @"";
    for (NSString *key in [params allKeys]) {

        paramstring = [paramstring stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,params[key]]];
    }

    _fullUrlString = [NSString stringWithFormat:@"%@?%@",[urlBodyArray firstObject],paramstring];
}


/**
 设置完整的url

 @param fullUrlString 完整的url
 */
-(void)setFullUrlString:(NSString *)fullUrlString
{
    if ([_fullUrlString isEqualToString:fullUrlString]) {
        return;
    }

    if (![fullUrlString containsString:@"://"]) {

        _fullUrlString = [NSString stringWithFormat:@"wrouter://"];
    }else{

        _fullUrlString = fullUrlString;
    }


    NSArray *arr1 = [fullUrlString componentsSeparatedByString:@"://"];


    //设置路由标记
    _schemeTitle = [arr1 firstObject];
    _urlString = [[fullUrlString componentsSeparatedByString:@"?"] firstObject];

    if (arr1.count > 1) {

        NSArray *urlBodyArray = [[arr1 lastObject] componentsSeparatedByString:@"?"];

        self.className = [[[urlBodyArray firstObject] componentsSeparatedByString:@"/"] lastObject];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        if (urlBodyArray.count > 1) {

            NSArray *urlParams = [[urlBodyArray lastObject] componentsSeparatedByString:@"&"];
            for (NSString *string in urlParams) {

                NSArray *keyValueArray = [string componentsSeparatedByString:@"="];
                [dict setObject:keyValueArray[0] forKey:keyValueArray[1]];
            }
            _params = dict;
        }
    }
}


/**
 设置类名

 @param className 要设置的类名
 */
-(void)setClassName:(NSString *)className
{
    if ([_className isEqualToString:className]) {
        return;
    }

    _className = className;

    if (_fullUrlString.length == 0) {
        _fullUrlString = [NSString stringWithFormat:@"%@://%@",_schemeTitle,_className];
    }

    NSArray *urlBodyArray = [_fullUrlString componentsSeparatedByString:@"?"];

    NSString *urls = [urlBodyArray firstObject];

    NSMutableArray *urlComponetArray = [NSMutableArray arrayWithArray:[urls componentsSeparatedByString:@"/"]];
    [urlComponetArray replaceObjectAtIndex:urlComponetArray.count-1 withObject:_className];

    urls = [urlComponetArray componentsJoinedByString:@"/"];


    NSString *paramstring = @"";
    if (urlBodyArray.count > 1) {
        paramstring = urlBodyArray[1];
    }

    _fullUrlString = [NSString stringWithFormat:@"%@%@",urls,paramstring];
}




@end
