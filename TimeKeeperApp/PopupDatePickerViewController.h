//
//  PopupDatePickerViewController.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/31.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDatePickerViewController.h"
// @interface 句より前にプロトコルを定義したい場合、かつ引数に自身のインスタンスを持つ場合には
// 自身のクラスを @class 句で定義する必要があります。
@class PopupDatePickerViewController;
@protocol PopupDatePickerViewDelegate <NSObject>
@end
@interface PopupDatePickerViewController : UIViewController
@property NSString *outDateString;
@property NSString *outTimeString;

@end
