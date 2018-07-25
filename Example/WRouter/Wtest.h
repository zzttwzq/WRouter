//
//  Wtest.h
//  WRouter_Example
//
//  Created by 吴志强 on 2018/7/25.
//  Copyright © 2018年 zzttwzq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^back)(NSString *string);

@interface Wtest : UIViewController

@property (nonatomic,copy) back backs;

@end
