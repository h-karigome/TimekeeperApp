//
//  WebViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/10/18.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // URLを入れる
    NSString *webPage = @"http://white-raven.hatenablog.com/entry/2015/03/10/015010";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: webPage]
                                       options:@{}
                             completionHandler:nil];
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
