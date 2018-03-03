//
//  SelectTimeViewController.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/09.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectTimePopupViewController.h"

@interface SelectTimeViewController : UIViewController<SelectTimePopupViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,copy) NSString *selectedDateString;
@property (nonatomic,copy) NSString *selectedTimeString;


@end
