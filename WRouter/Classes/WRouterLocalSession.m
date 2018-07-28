//
//  WRouterLocalSession.m
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import "WRouterLocalSession.h"

@implementation WRouterLocalSession

/**
 保存路由文件到本地
 */
+ (void) saveToFile;
{

}


/**
 从某个文件中读取路由配置信息

 @param fileName 文件名
 @return 返回路由信息
 */
+ (NSDictionary *) readFromFileName:(NSString *)fileName;
{
    NSString *filePath = [WFileManager getFilePathWithFileName:fileName];
    return [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
}


/**
 从本地读取路由文件

 @return 返回路由文件里的字典
 */
+ (NSDictionary *) readFromLocal;
{
    return [self readFromFileName:@"wrouter.plist"];
}

@end
