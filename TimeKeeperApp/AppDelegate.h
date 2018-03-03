//
//  AppDelegate.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, retain) UIColor *themeColer;// これの意味も復習し直さないと
@property (strong, nonatomic) UIWindow *window;

@property bool isSelectedTodayOutTime;

@end

