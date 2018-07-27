
    //
//  WRouter.m
//  Pods-WRouter_Example
//
//  Created by 吴志强 on 2018/7/26.
//

#import "WRouter.h"

@interface WRouter ()

@property (nonatomic,strong) NSMutableArray *entryList;
@property (nonatomic,strong) NSMutableDictionary *routerInfos;
@property (nonatomic,strong) NSMutableArray *availableHosts;
@property (nonatomic,strong) NSMutableArray *availableHostTitles;

@end

@implementation WRouter

static WRouter *globalRouters = nil;
static dispatch_once_t once;

#pragma mark - 添加路由
/**
 单利路由

 @return 返回单利路由
 */
+ (instancetype) globalRouter;
{
    dispatch_once(&once, ^{

        globalRouters = [[self alloc] init];
        globalRouters.routerInfos = [NSMutableDictionary dictionary];
        globalRouters.availableHosts = [NSMutableArray array];
        globalRouters.entryList = [NSMutableArray array];
        globalRouters.availableHostTitles = [NSMutableArray arrayWithObjects:@"https",@"http",@"WRouter", nil];
    });
    return globalRouters;
}


/**
 从plist中获取路由信息

 @param fileName 文件名
 */
- (void) addRouterFromePlistFile:(NSString *)fileName;
{
    if (fileName.length == 0) {

        [WRouterURLDecoder showDebugLog:@"文件名不能为空！"];
        return;
    }

    [self.routerInfos addEntriesFromDictionary:[WRouterLocalSession readFromFileName:fileName]];
}


/**
 从数组中批量添加到路由中

 @param array 要添加的数组
 */
- (void) addRouterFromeArray:(NSArray *)array;
{
    for (NSString *scheme in array) {

        if (![WRouter entryListScheme:scheme] &&
            scheme.length > 0) {

            WRouterEntry *newEntry = [[WRouterEntry alloc] initWithScheme:scheme];
            [self.entryList addObject:newEntry];

            [self.entryList setValue:scheme forKey:scheme];
        }
        else{

            [WRouterURLDecoder showDebugLog:[NSString stringWithFormat:@"无法添加scheme %@",scheme]];
        }
    }
}


/**
 将字典添加到数组中

 @param dict 要添加字典
 */
- (void) addRouterFromeDict:(NSDictionary *)dict;
{
    for (NSString *key in dict) {

        NSString *value = dict[key];
        if (![WRouter entryListScheme:value] &&
            value.length > 0) {

            WRouterEntry *newEntry = [[WRouterEntry alloc] initWithScheme:value];
            [self.entryList addObject:newEntry];

            [self.entryList setValue:value forKey:key];
        }
        else{

            [WRouterURLDecoder showDebugLog:[NSString stringWithFormat:@"无法添加scheme key:%@  value:%@",key,value]];
        }
    }
}


#pragma mark - 添加路由信息
/**
 添加host

 @param array 要添加的host数组
 */
- (void)addHosts:(NSArray *)array;
{
    [self.availableHosts addObjectsFromArray:array];
}


/**
 添加urltitle

 @param array 要添加的urltitle
 */
- (void) addHostTitles:(NSArray *)array;
{
    [self.availableHostTitles addObjectsFromArray:array];
}



/**
 添加路由

 @param scheme 要添加的路由规则
 @param handleBlock 处理回调
 */
- (void) addScheme:(NSString *)scheme
       handleBlock:(WRouterCallBack)handleBlock;
{
    WRouterEntry *entry = [self entryWithScheme:scheme];
    if (entry) {

        entry.callBackHanler = handleBlock;
    }
    else{

        WRouterURLDecoder *decoder = [self decoderWithScheme:scheme];
        WRouterEntry *entry = [[WRouterEntry alloc] initWithDecoder:decoder];

        [self.entryList addObject:entry];
        [self.routerInfos setObject:decoder.urlString forKey:decoder.className];
        [self.routerInfos setObject:decoder.urlString forKey:decoder.urlString];
    }
}

#pragma mark - 验证路由
/**
 查看路由列表的所有key中是否包含

 @param scheme url
 @return 返回包含的key
 */
- (NSString *) getSchemeFromeAllKeys:(NSString *)scheme;
{
    //1.查找路由是否在路由列表中 所有key中
    for (NSString *key in [self.routerInfos allKeys]) {

        if ([key containsString:scheme]) {

            return self.routerInfos[key];
        }
    }

    return nil;
}


/**
 查看路由列表的所有value中是否包含

 @param scheme url
 @return 返回包含的value
 */
- (NSString *) getSchemeFromeAllValues:(NSString *)scheme;
{
    //1.查找路由是否在路由列表中 所有key中
    for (NSString *key in [self.routerInfos allValues]) {

        if ([key containsString:scheme]) {

            return scheme;
        }
    }

    return nil;
}


/**
 获取解析结果

 @param scheme 要解析的字符串
 @return 返回解析结果
 */
- (WRouterURLDecoder *) decoderWithScheme:(NSString *)scheme;
{
    WRouterURLDecoder *tempDecoder = [[WRouterURLDecoder alloc] initWithScheme:scheme];
    if (tempDecoder) {

        if (self.custmDecodeHandler) {
            self.custmDecodeHandler(tempDecoder);
            return tempDecoder;
        }

        //在key中，那么先取key 在拼接参数 然后实体化一个decoder
        NSString *valueScheme = [self getSchemeFromeAllKeys:tempDecoder.urlString];
        if (valueScheme) {

            scheme = valueScheme;

            if (tempDecoder.params.count > 0) {
                scheme = [NSString stringWithFormat:@"%@?%@",valueScheme,tempDecoder.params];
            }

            WRouterURLDecoder *decoder = [[WRouterURLDecoder alloc] initWithScheme:scheme];
            decoder.routerType = WRouterType_Exist_Router;
            return decoder;
        }
        //直接在value 中 就直接跳
        else if ([self getSchemeFromeAllValues:tempDecoder.urlString]){

            tempDecoder.routerType = WRouterType_Exist_Router;
            return tempDecoder;
        }
        else{

            //包含请求头
            if ([self.availableHostTitles containsObject:tempDecoder.host]) {

                //host包含，应该是公司的其他app 默认跳转
                if ([self.availableHosts containsObject:tempDecoder.host]) {

                    //是https http开头的
                    if ([tempDecoder.hostTile isEqualToString:@"https"] ||
                        [tempDecoder.hostTile isEqualToString:@"http"]) {

                        tempDecoder.routerType = WRouterType_Company_HTML;
                        return tempDecoder;
                    }
                    else{

                        //包含头 和 host 那就强制解析
                        tempDecoder.routerType = WRouterType_App_UNKnownRouter;
                        return tempDecoder;
                    }
                }
                else{

                    //是https http开头的
                    if ([tempDecoder.hostTile isEqualToString:@"https"] ||
                        [tempDecoder.hostTile isEqualToString:@"http"]) {

                        tempDecoder.routerType = WRouterType_Other_HTML;
                        return tempDecoder;
                    }
                    else{

                        //包含头 和 host 那就强制解析
                        tempDecoder.routerType = WRouterType_App_UNKnownRouter;
                        return tempDecoder;
                    }
                }
            }
            //不包含请求头
            else {

                //host包含，应该是公司的其他app 默认跳转
                if ([self.availableHosts containsObject:tempDecoder.host]) {

                    tempDecoder.routerType = WRouterType_Company_Router;
                    return tempDecoder;
                }
                //其他公司的app 默认是跳转的
                else{

                    tempDecoder.routerType = WRouterType_Other_Router;
                    return tempDecoder;
                }
            }
        }
    }
    return nil;
}


/**
 获取路由列表中的实体

 @param scheme url
 @return 返回实体
 */
- (WRouterEntry *) entryWithScheme:(NSString *)scheme;
{
    WRouterURLDecoder *decoder = [[WRouterURLDecoder alloc] initWithScheme:scheme];
    if (decoder) {

        for (WRouterEntry *listEntry in self.entryList) {

            if ([listEntry.scheme isEqualToString:decoder.urlString]) {

                return listEntry;
            }
        }
    }
}

#pragma mark - 推送路由
/**
 通过路由实体获取控制器

 @param entry 路由实体
 @return 返回控制器
 */
+ (UIViewController *) getViewControllerFromeEntry:(WRouterEntry *)entry;
{
    if (entry) {

        //创建控制器 并赋予新值
        Class obj = NSClassFromString(entry.className);
        UIViewController *viewCotroller = [obj new];
        [viewCotroller setObjectWithDict:entry.params];

        if (entry.callBackHanler) {
            entry.callBackHanler(viewCotroller,callBack);
        }

        return viewCotroller;
    }

    return nil;
}


/**
 通过路由获取控制器

 @param scheme 路由信息
 @param handleBlock 处理回调
 @return 返回控制器
 */
+ (UIViewController *) getViewControllerFromeScheme:(NSString *)scheme
                          handleBlock:(WRouterCallBack)handleBlock;
{
    WRouterEntry *entry = [self entryWithScheme:scheme];
    entry.callBackHanler = handleBlock;

    return [self getViewControllerFromeEntry:entry];
}


/**
 跳转页面

 @param scheme 路由规则
 @param target 将要跳转的控制器，如果传入空就使用present方法
 @param params 参数
 @param callBack 回调（如果前面有处理回调，就会调用该方法，非常适合多个block回调的情况）
 */
- (void) pushViewControllerWithScheme:(NSString *)scheme
                               target:(UIViewController *)target
                               params:(NSDictionary *)params
                             callBack:(DictionaryBlock)callBack;
{
    //1.获取解析数据
    WRouterURLDecoder *decoder = [self decoderWithScheme:scheme];


    //2.判断跳转类型
    if (decoder.routerType == WRouterType_Exist_Router||
        decoder.routerType == WRouterType_App_UNKnownRouter) {

        WRouterEntry *entry = [self entryWithScheme:scheme];
        if (entry) {

            UIViewController *controller = [self getViewControllerFromeEntry:entry];

            if (target) {

                [target.navigationController pushViewController:viewCotroller animated:YES];
            }else{

                SEL dismissbtn = NSSelectorFromString(@"showDismissBtn");
                if ([(UIViewController *)viewCotroller respondsToSelector:dismissbtn]) {
                    [(UIViewController *)viewCotroller performSelector:dismissbtn withObject:nil];
                }

                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewCotroller];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }
    else if (decoder.routerType == WRouterType_Company_Router) {

        //如果不包含就跳转到其他的app里
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        }
    }
    else if (decoder.routerType == WRouterType_Other_Router) {

        if (!self.NotPushUNKnowScheme) {

            //如果不包含就跳转到其他的app里
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
            }
        }
    }
    else if (decoder.routerType == WRouterType_Company_HTML ||
             decoder.routerType == WRouterType_Other_HTML) {

        if (self.unHandledHtmlUrl) {
            self.unHandledHtmlUrl(scheme);
        }
    }
}
@end
