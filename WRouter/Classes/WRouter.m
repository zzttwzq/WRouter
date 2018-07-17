
    //
//  WRouter.m
//  AFNetworking
//
//  Created by 吴志强 on 2018/3/13.
//

#import "WRouter.h"

@interface WRouter ()

/**
 路由列表
 */
@property (nonatomic,strong) NSMutableArray *routerList;

@end

@implementation WRouter

#pragma mark - 获取路由信息
/**
 创建单利

 @return 返回单利
 */
+ (instancetype)globalRouters;
{
    static WRouter *globalRouters = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{

        globalRouters = [[self alloc] init];
        globalRouters.routerInfoDict = [NSMutableDictionary dictionary];
        globalRouters.routerList = [NSMutableArray array];
        globalRouters.urlHosts = [NSMutableArray array];
        globalRouters.schemeTitles = [NSMutableArray arrayWithObjects:@"https",@"http",@"WRouter", nil];
    });

    return globalRouters;
}


/**
 验证是否可以跳转

 @param urlScheme 路径
 @return 返回结果
 */
-(WRouterEntry *)validateUrlScheme:(NSString *)urlScheme;
{
    NSString *scheme = urlScheme;

    if (!scheme ||
        scheme.length == 0) {
        return nil;
    }

    //1.如果是简单的key就去路由列表中查找
    if (![scheme containsString:@"://"]) {
        scheme = [_routerInfoDict objectForKey:scheme];
    }

    WRouterEntry *entry = [[WRouterEntry alloc] initWithUrlString:scheme];

    //2.判断http类型的scheme
    if ([entry.schemeTitle isEqualToString:@"http"] ||
        [entry.schemeTitle isEqualToString:@"https"]) {

        // 判断是否是其他h5
        if (![[WRouter globalRouters].urlHosts containsObject:entry.host]) {
            return entry;
        }
    }
    //查看其他scheme类型是否支持
    else if (![[WRouter globalRouters].schemeTitles containsObject:entry.schemeTitle]){

        if (entry.schemeTitle.length > 0 &&
            ![entry.schemeTitle isEqualToString:@"<null>"] &&
            ![entry.schemeTitle isEqualToString:@"(null)"]) {

            NSString *string = [NSString stringWithFormat:@"<WRouter> 匹配到一个不熟知的scheme类型 :%@  URL:%@",entry.schemeTitle,scheme];
            [WRouter showInfo:string];

            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
            }
        }

        return nil;
    }

    //3.在全局路由中查找
    for (WRouterEntry *listEntry in _routerList) {

        if ([listEntry.urlString isEqualToString:entry.urlString]) {

            return listEntry;
        }
    }

    //4.判断.classname 是否在路由中包含
    if ([[self.routerInfoDict allKeys] containsObject:entry.className]) {

        return [self validateUrlScheme:entry.className];
    }

    return nil;
}


/**
 从本地文件中获取路由配置信息

 @param fileName 本地文件名称
 */
+ (void) getRouterInfoFromLocalFile:(NSString *)fileName;
{
    WPlistManager *plist = [WPlistManager plistWithName:fileName];

    NSDictionary *dict = [plist getDict];
    for (NSString *key in dict) {
        
        [[WRouter globalRouters] addGlobalRouterWithUrlScheme:dict[key] handler:nil];
    }
}


/**
 从网络中获取路由配置信息

 @param urlString url
 @param fileName 文件名
 */
+ (void) getRouterInfoFromURLString:(NSString *)urlString
                           fileName:(NSString *)fileName;
{
    [WNetwork getTaskWithURL:urlString
                      params:nil
          setHttpHeaderfield:nil
                     success:^(NSDictionary *respone) {

                         if ([respone[@"result"] integerValue] == 1) {

                             [[WRouter globalRouters].routerInfoDict addEntriesFromDictionary:respone[@"data"]];
                         }
                     } faild:^(NSError *error) {
                     }];
}


#pragma mark - 添加路由
/**
 添加全局路由

 @param urlScheme 路径
 @param handler 回调block
 */
- (void) addGlobalRouterWithUrlScheme:(NSString *)urlScheme
                              handler:(WRouterCallBack)handler;
{
    //如果是简单的key就去路由列表中查找
    if (![urlScheme containsString:@"://"]) {
        urlScheme = [self.routerInfoDict objectForKey:urlScheme];
    }

    WRouterEntry *validateEntry = [self validateUrlScheme:urlScheme];
    if (validateEntry) {
        validateEntry.handler = handler;
    }
    else{

        WRouterEntry *entry = [[WRouterEntry alloc] initWithUrlString:urlScheme];
        entry.handler = handler;
        [self.routerList addObject:entry];
    }
}


/**
 注册路由

 @param urlScheme url
 @param params 路由参数
 @param callBack 处理回调
 @return 返回实例化的跳转页面
 */
- (UIViewController *) registerRouterWithScheme:(NSString *)urlScheme
                                         params:(NSDictionary *)params
                                       callBack:(IDDataBlock)callBack;
{
    //如果是简单的key就去路由列表中查找
    if (![urlScheme containsString:@"://"]) {
        urlScheme = [self.routerInfoDict objectForKey:urlScheme];
    }

    WRouterEntry *entry = [[WRouterEntry alloc] initWithUrlString:urlScheme];
    entry.params = params;

    //创建控制器 并赋予新值
    Class obj = NSClassFromString(entry.className);
    id viewCotroller = [obj new];
    [viewCotroller setObjectWithDict:entry.params];

    if (callBack) {
        callBack(viewCotroller);
    }

    return viewCotroller;
}


#pragma mark - 跳转到对应页面
/**
 直接push到页面

 @param scheme 路由
 @param target 要再哪个控制器跳转
 @param params 路由参数
 @param callBack 回调参数
 */
+ (void) pushRouterWithScheme:(NSString *)scheme
                       target:(UIViewController *)target
                       params:(NSDictionary *)params
                     callBack:(DictionaryBlock)callBack;
{
    WRouterEntry *entry = [[self globalRouters] validateUrlScheme:scheme];
    entry.params = params;

    // <! http规则 !>查找是否是html链接，如果是直接跳给定的h5页面
    if ([entry.schemeTitle containsString:@"http"]) {

        NSMutableDictionary *dcit = [NSMutableDictionary dictionaryWithDictionary:params];
        [dcit setObject:scheme forKey:@"groupCode"];
        [self pushRouterWithScheme:@"htmlpage" target:target params:dcit callBack:callBack];
        return ;
    }

    if (entry) {

        //创建控制器 并赋予新值
        Class obj = NSClassFromString(entry.className);
        UIViewController *viewCotroller = [obj new];
        [viewCotroller setObjectWithDict:entry.params];

        if (entry.handler) {
            entry.handler(viewCotroller,callBack);
        }

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
    else{

        NSString *string = [NSString stringWithFormat:@"<WRouter:> 没有匹配到路由规则 url:%@ \n params:%@",scheme,params];
        [WRouter showInfo:string];
    }
}


/**
 保存到文件 会自动创建文件 保存路由文件到本地
 */
//-(void)saveTofile;
//{
//    NSString *string = @"";
//
//    for (WRouterURLEntry *entry in self.routerList) {
//
//        entry.useNavigation = YES;
//        entry.showInWindow = YES;
//
//        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@  ",entry.fullURL]];
//    }
//
//    NSString *filePath = [WFileManager createFileBasePath:WFileBasePath_Document name:@"wrouter" ofType:@"plist" content:string overWrite:NO];
//
//    if (filePath) {
//
//        NSLog(@"保存文件");
//    }
//}

+ (void) showInfo:(NSString *)string
{
    #ifdef DEBUG

        NSLog(@"%@",string);

    #endif
}

@end
