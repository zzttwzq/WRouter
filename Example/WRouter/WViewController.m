//
//  WViewController.m
//  WRouter
//
//  Created by zzttwzq on 07/17/2018.
//  Copyright (c) 2018 zzttwzq. All rights reserved.
//

#import "WViewController.h"
#import <WRouter/WRouter.h>

#import "routerConfig.h"

@interface WViewController ()

@end

@implementation WViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];

    [routerConfig configRouter];

    NSArray *array1 = [WRouter globalRouter].entryList;
    NSArray *array2 = [WRouter globalRouter].availableHosts;
    NSArray *array3 = [WRouter globalRouter].availableHostTitles;
    NSDictionary *array4 = [WRouter globalRouter].routerInfos;

    for (int i = 0; i<10; i++) {

        UILabel *label = [UILabel new];
        label.frame = CGRectMake(100, 100+30*i, 100, 20);
        label.text = @"page1";
        label.backgroundColor = [UIColor redColor];
        label.tag = 1000+i;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        [self.view addSubview:label];
    }
}

- (void)click:(UITapGestureRecognizer *)tap
{
    int index = (int)tap.view.tag - 1000;

    if (index == 0) {

        void(^block)(NSDictionary *dict) = ^(NSDictionary *dict){

            NSLog(@">>>>>>>>>>>>%@",dict);
        };

        NSDictionary *dict = @{@"isActive":@(1),
                               @"activeTime":@"0.36363",
                               @"activeName":@"了了了",
                               @"activeArray":@[@"成",@"功",@"了"],
                               @"name":@"wu",
                               @"age":@(100),
                               @"block":block,
                               };

        [WRouter pushViewControllerWithScheme:@"page1" target:self params:dict callBack:^(NSDictionary * _Nullable responseDict) {

            NSLog(@"%@",responseDict);
        }];
    }
    else if (index == 1) {

        [WRouter pushViewControllerWithScheme:@"https://www.baidu.com" target:self params:nil callBack:^(NSDictionary * _Nullable responseDict) {

            NSLog(@"%@",responseDict);
        }];
    }
    else if (index == 2) {

        [WRouter pushViewControllerWithScheme:@"hengmeiapp://comlay/main/gotopage?routerpath=page1&counponid=&counponmoney=&dikoumoney=&jifen=&ordercode=${res.retData.orderCode}&orderid=${res.retData.orderId}&ordermoney=${money}&paymoney=${money}" target:self params:nil callBack:^(NSDictionary * _Nullable responseDict) {

            NSLog(@"%@",responseDict);
        }];
    }
    else if (index == 3) {

    }
    else if (index == 4) {

    }
    else if (index == 5) {

    }
    else if (index == 6) {

    }
    else if (index == 7) {

    }
    else if (index == 8) {

    }
    else if (index == 9) {

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
