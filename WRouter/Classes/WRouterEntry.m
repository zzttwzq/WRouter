//
//  WRouterEntry.m
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import "WRouterEntry.h"

@implementation WRouterEntry

+ (WRouterEntry *) entryWithScheme:(NSString *)scheme;
{
    WRouterURLDecoder *decoder = [[WRouterURLDecoder alloc] initWithScheme:scheme];

    WRouterEntry *entry = [WRouterEntry new];
    entry.routerUrl = decoder.urlString;
    entry.className = decoder.className;
    entry.params = decoder.params;

    return entry;
}

+ (WRouterEntry *) entryWithDecoder:(WRouterURLDecoder *)decoder;
{
    WRouterEntry *entry = [WRouterEntry new];
    entry.routerUrl = decoder.urlString;
    entry.className = decoder.className;
    entry.params = decoder.params;

    return entry;
}


@end
