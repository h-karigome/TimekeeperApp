//
//  DoTaskForTodoViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2018/01/22.
//  Copyright © 2018年 Haruna Karigome. All rights reserved.
//

#import "DotaskForTodoViewController.h"
#import "TextDataManager.h"

@interface DoTaskForTodoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *doTextView;
@property (weak, nonatomic) IBOutlet UIButton *doTextSaveButton;

@end

@implementation DoTaskForTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"****%@", _inputDate);
    self.navigationItem.title = _inputDate;
    // Do any additional setup after loading the view.
//    [TextDataManager addColumnTodoFinish];  // add 20170127
}
- (IBAction)pushSaveButton:(UIButton *)sender {
//    [TextDataManager updateTodoData:<#(NSString *)#>
//                         actionText:<#(NSString *)#>
//                           clearFlg:@"CLEAR"
//                           todoText:<#(NSString *)#>]
    
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
