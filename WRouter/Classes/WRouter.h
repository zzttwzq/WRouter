//
//  WRouter.h
//  AFNetworking
//
//  Created by 吴志强 on 2018/3/13.
//

#import "WRouterEntry.h"
#import "NSObject+Whandler.h"

typedef void (^DictionaryBlock)(NSDictionary * _Nullable responseDict);

@interface WRouter : NSObject
/**
 获取plist路由文件的信息
 */
@property (nonatomic,strong) NSMutableDictionary *routerInfoDict;

/**
 路由头
 */
@property (nonatomic,strong) NSMutableArray *schemeTitles;

/**
 host列表
 */
@property (nonatomic,strong) NSMutableArray *urlHosts;



#pragma mark - 获取路由信息
/**
 创建单利

 @return 返回单利
 */
+ (instancetype) globalRouters;


/**
 从本地文件中获取路由配置信息

 @param fileName 本地文件名称
 */
+ (void) getRouterInfoFromLocalFile:(NSString *)fileName;


/**
 从网络中获取路由配置信息

 @param urlString url
 @param fileName 文件名
 */
+ (void) getRouterInfoFromURLString:(NSString *)urlString
                           fileName:(NSString *)fileName;


/**
 验证是否可以跳转

 @param urlScheme 路径
 @return 返回结果
 */
- (WRouterEntry *) validateUrlScheme:(NSString *)urlScheme;


#pragma mark - 添加路由
/**
 添加全局路由

 @param urlScheme 路径
 @param handler 回调block
 */
- (void) addGlobalRouterWithUrlScheme:(NSString *)urlScheme
                              handler:(WRouterCallBack)handler;


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
@end
