//
//  WRouter.h
//  Pods-WRouter_Example
//
//  Created by 吴志强 on 2018/7/26.
//

#import <UIKit/UIKit.h>
#import "WRouterEntry.h"
#import "WRouterLocalSession.h"

@interface WRouter : NSObject
/**
 需要跳转到h5回调
 */
@property (nonatomic,copy) StringBlock unHandledHtmlUrl;

@property (nonatomic,copy) decoderBlock custmDecodeHandler;

/**
 如果是其他公司的app 默认是跳转的
 */
@property (nonatomic,assign) BOOL NotPushUNKnowScheme;


@property (nonatomic,readonly) NSMutableArray *entryList;
@property (nonatomic,readonly) NSMutableDictionary *routerInfos;
@property (nonatomic,readonly) NSMutableArray *availableHosts;
@property (nonatomic,readonly) NSMutableArray *availableHostTitles;


#pragma mark - 添加路由
/**
 单利路由

 @return 返回单利路由
 */
+ (instancetype) globalRouter;

/**
 从plist中获取路由信息

 @param fileName 文件名
 */
- (void) addRouterFromePlistFile:(NSString *)fileName;

/**
 从数组中批量添加到路由中

 @param array 要添加的数组
 */
- (void) addRouterFromeArray:(NSArray *)array;

/**
 将字典添加到数组中

 @param dict 要添加字典
 */
- (void) addRouterFromeDict:(NSDictionary *)dict;


#pragma mark - 添加路由信息
/**
 添加host

 @param array 要添加的host数组
 */
- (void) addHosts:(NSArray *)array;

/**
 添加urltitle

 @param array 要添加的urltitle
 */
- (void) addHostTitles:(NSArray *)array;

/**
 添加路由

 @param scheme 要添加的路由规则
 @param handleBlock 处理方法
 */
- (void) addScheme:(NSString *)scheme
       handleBlock:(WRouterCallBack)handleBlock;


#pragma mark - 推送路由
/**
 通过路由获取控制器

 @param scheme 路由信息
 @param callBack 处理回调
 @return 返回控制器
 */
+ (UIViewController *) getViewControllerFromeScheme:(NSString *)scheme
                                           callBack:(DictionaryBlock)callBack;

/**
 跳转页面

 @param scheme 路由规则
 @param target 将要跳转的控制器，如果传入空就使用present方法
 @param params 参数
 @param callBack 回调（如果前面有处理回调，就会调用该方法，非常适合多个block回调的情况）
 */
+ (void) pushViewControllerWithScheme:(NSString *)scheme
                               target:(UIViewController *)target
                               params:(NSDictionary *)params
                             callBack:(DictionaryBlock)callBack;

#pragma mark - 验证路由
/**
 查看路由列表的所有key中是否包含

 @param scheme url
 @return 返回包含的key
 */
- (NSString *) getSchemeFromeAllKeys:(NSString *)scheme;


/**
 查看路由列表的所有value中是否包含

 @param scheme url
 @return 返回包含的value
 */
- (NSString *) getSchemeFromeAllValues:(NSString *)scheme;


/**
 获取解析结果

 @param scheme 要解析的字符串
 @return 返回解析结果
 */
- (WRouterURLDecoder *) decoderWithScheme:(NSString *)scheme;


/**
 获取路由列表中的实体

 @param scheme url
 @return 返回实体
 */
+ (WRouterEntry *) getRouterEntryWithScheme:(NSString *)scheme;


/**
 从获取路由列表中的实体

 @param decoder 解析器
 @return 返回实体
 */
+ (WRouterEntry *) getRouterEntryWithDecoder:(WRouterURLDecoder *)decoder;


@end
