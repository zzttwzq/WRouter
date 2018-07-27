//
//  WRouterEntry.h
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import <Foundation/Foundation.h>
#import "WRouterURLDecoder.h"

@interface WRouterEntry : NSObject

@property (nonatomic,copy) WRouterCallBack _Nullable callBackHanler;

@property (nonatomic,copy) NSString *scheme;

@property (nonatomic,strong) WRouterURLDecoder *decoder;


- (instancetype) initWithScheme:(NSString *)scheme;

- (instancetype) initWithDecoder:(WRouterURLDecoder *)decoder;


@end
