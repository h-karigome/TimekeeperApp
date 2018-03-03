//
//  OutTimeListViewController.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutTimeListViewController: UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *outTimeListTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeOutTimeListBurron;

@property NSMutableArray *outDateArray;

@end
