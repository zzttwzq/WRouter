//
//  WRouterURLDecoder.h
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import <Foundation/Foundation.h>
#import "NSObject+Whandler.h"

@class WRouterURLDecoder;

typedef NS_ENUM(NSInteger,WRouterType) {
    WRouterType_UNSPECIFIED,         //缺省未指定路由类型
    WRouterType_Exist_Router,        //存在的路由，直接跳转就好
    WRouterType_Company_Router,      //公司其他app的路由，host可以匹配到，直接跳转到对应app
    WRouterType_Other_Router,        //不认识的路由，默认是跳转到对应app中的
    WRouterType_Company_HTML,        //公司内部的html
    WRouterType_Other_HTML,          //其他的html
    WRouterType_App_UNKnownRouter    //头是app支持的，host是或者不是，那就都强制解析
};



typedef void (^IDDataBlock)(id _Nullable data);

typedef void (^WRouterCallBack)(id _Nullable viewController,IDDataBlock _Nullable dataCallBack);

typedef void (^DictionaryBlock)(NSDictionary * _Nullable responseDict);

typedef void (^StringBlock)(NSString * _Nullable urlString);

typedef void (^decoderBlock)(WRouterURLDecoder * _Nullable urlString);



@interface WRouterURLDecoder : NSObject

@property (nonatomic,assign) WRouterType routerType;

@property (nonatomic,copy) NSString *className;

@property (nonatomic,copy) NSString *urlString;

@property (nonatomic,copy) NSString *fullUrlString;

@property (nonatomic,copy) NSString *host;

@property (nonatomic,copy) NSString *hostTile;

@property (nonatomic,copy) NSArray *routerStack;

@property (nonatomic,copy) NSDictionary *params;


/**
 初始化scheme

 @param scheme 初始化的scheme
 @return 返回decoder实例
 */
- (instancetype) initWithScheme:(NSString *)scheme;


/**
 解析参数字符串成字典

 @param paramsString 要解析的字符串
 @return 返回字典
 */
+ (NSDictionary *) getParamsWithString:(NSString *)paramsString;


/**
 显示错误消息

 @param log 消息
 */
+ (void) showDebugLog:(NSString *)log;

@end
