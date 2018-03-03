//
//  SelectTimePopupViewController.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/11/25.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectTimePopupViewController;
@protocol SelectTimePopupViewDelegate <NSObject>
@end

@interface SelectTimePopupViewController : UIViewController
@property (nonatomic) id stDelegate;
@end
