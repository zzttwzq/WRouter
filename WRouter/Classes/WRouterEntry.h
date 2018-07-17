//
//  WRouterEntry.h
//  美丽吧
//
//  Created by 吴志强 on 2018/6/26.
//  Copyright © 2018年 吴志强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^IDDataBlock)(id _Nullable data);

//路由回调
typedef void (^WRouterCallBack)(id _Nullable viewController,IDDataBlock _Nullable dataCallBack);

@interface WRouterEntry : NSObject

/**
 初始化方法

 @param urlString url字符串
 @retur 返回实例
 */
- (instancetype _Nullable ) initWithUrlString:(NSString *_Nullable)urlString;


/**
 获取参数字典

 @param paramString 参数字符串
 @return 返回参数字典
 */
+ (NSDictionary *_Nullable)getParamsWithString:(NSString *_Nullable)paramString;





/**
 路由的scheme或者是http （默认WRouter也可以是其他的）
 */
@property (nonatomic,copy) NSString * _Nullable schemeTitle;


/**
 当前路由对应的类名称
 */
@property (nonatomic,copy) NSString * _Nullable host;


/**
 当前路由对应的类名称
 */
@property (nonatomic,copy) NSString * _Nullable className;


/**
 url不带参数 （根据这个来判断路由）
 */
@property (nonatomic,copy) NSString * _Nullable urlString;


/**
 完整带参数的url
 */
@property (nonatomic,copy) NSString * _Nullable fullUrlString;


/**
 当前路由对应的参数
 */
@property (nonatomic,copy) NSDictionary * _Nullable params;


/**
 路由对应的回调处理事件
 */
@property (nonatomic,copy) WRouterCallBack _Nullable handler;
@end
