//
//  WRouterEntry.m
//  Pods
//
//  Created by 吴志强 on 2018/7/26.
//

#import "WRouterEntry.h"

@implementation WRouterEntry

- (instancetype) initWithScheme:(NSString *)scheme;
{
    self = [super init];
    if (self) {

        self.decoder = [[WRouterURLDecoder alloc] initWithScheme:scheme];
        self.scheme = self.decoder.urlString;
    }
    return self;
}

- (instancetype) initWithDecoder:(WRouterURLDecoder *)decoder;
{
    self = [super init];
    if (self) {

        self.decoder = decoder;
        self.scheme = self.decoder.urlString;
    }
    return self;
}
@end
