//
//  WRouterEntry.h
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import <Foundation/Foundation.h>
#import "WRouterURLDecoder.h"

@interface WRouterEntry : NSObject
/**
 路由直接能识别的url
 */
@property (nonatomic,copy) NSString *routerUrl;


/**
 对应的类名
 */
@property (nonatomic,copy) NSString *className;


/**
 对应的参数
 */
@property (nonatomic,strong) NSDictionary *params;


/**
 对应的回调
 */
@property (nonatomic,copy) WRouterCallBack _Nullable callBackHanler;



+ (WRouterEntry *) entryWithScheme:(NSString *)scheme;

+ (WRouterEntry *) entryWithDecoder:(WRouterURLDecoder *)decoder;

@end
