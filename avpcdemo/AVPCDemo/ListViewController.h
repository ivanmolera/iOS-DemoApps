//
//  ListViewController.h
//  AVPCDemo
//
//  Created by IVAN MOLERA on 4/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSString *endpoint;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL isPageRefreshing;


- (void)loadDataSourceWithEndPoint:(NSString*)endpoint;
- (void)loadDataSourceWithEndPoint:(NSString*)endpoint page:(int)page;

@end
