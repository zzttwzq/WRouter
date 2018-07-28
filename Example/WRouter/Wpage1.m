//
//  Wpage1.m
//  WRouter_Example
//
//  Created by 吴志强 on 2018/7/27.
//  Copyright © 2018年 zzttwzq. All rights reserved.
//

#import "Wpage1.h"

@interface Wpage1 ()

@end

@implementation Wpage1

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    self.backs(@"111");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UILabel *label = [UILabel new];
    label.frame = CGRectMake(100, 100, 100, 100);
    label.text = @"page1";
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
