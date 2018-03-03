//
//  OutTimeListTableViewCell.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutTimeListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *outTimeDateLabel; // 入力日
@property (weak, nonatomic) IBOutlet UILabel *inTimeLabel; // 出社時間
@property (weak, nonatomic) IBOutlet UILabel *outTimeLabel; // 退勤時間
@property (weak, nonatomic) IBOutlet UILabel *workingTimeLabel; // 勤務時間
@property (weak, nonatomic) IBOutlet UILabel *iconLabel; // りんごアイコン
@property (weak, nonatomic) IBOutlet UILabel *breakTimeLabel; // 休憩時間

@property (weak, nonatomic) IBOutlet UILabel *sumWoringTimeLabel; // 各月の総勤務時間
@property (weak, nonatomic) IBOutlet UILabel *sumWorkingDayLabel; // 各月の営業日数
@property (weak, nonatomic) IBOutlet UIImageView *inputtedImageView; // 入力済みスタンプ


@end
