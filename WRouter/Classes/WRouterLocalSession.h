//
//  WRouterLocalSession.h
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import <Foundation/Foundation.h>
#import <WExpandLibrary/WExpandHeader.h>

@interface WRouterLocalSession : NSObject

/**
 保存路由文件到本地
 */
+ (void) saveToFile;


/**
 从某个文件中读取路由配置信息

 @param fileName 文件名
 @return 返回路由信息
 */
+ (NSDictionary *) readFromFileName:(NSString *)fileName;


/**
 从本地读取路由文件

 @return 返回路由文件里的字典
 */
+ (NSDictionary *) readFromLocal;

@end
