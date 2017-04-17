//
//  ListViewController.m
//  AVPCDemo
//
//  Created by IVAN MOLERA on 4/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import "ListViewController.h"
#import "SWRevealViewController.h"
#import "RightViewController.h"
#import "ListItem.h"
#import "Reachability.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _isPageRefreshing = NO;

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self.rightbarButton setTarget: self.revealViewController];
        [self.rightbarButton setAction: @selector( rightRevealToggle: )];
        
        RightViewController *rightViewController = [[RightViewController alloc] init];
        revealViewController.rightViewController = rightViewController;
    }
}

- (void)loadDataSourceWithEndPoint:(NSString*)endpoint {
    [self loadDataSourceWithEndPoint:endpoint page:-1];
}

- (void)loadDataSourceWithEndPoint:(NSString*)endpoint page:(int)page {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if(networkStatus == NotReachable) {
        
        NSLog(@"There IS NO internet connection");
        
    }
    else {
        
        NSLog(@"There IS internet connection");

        _dataSource = [[NSMutableArray alloc] init];
        
        _endpoint = endpoint;
        _page = page;
        
        if(page >= 0) {
            _endpoint = [NSString stringWithFormat:@"%@?page=%d", _endpoint, _page];
        }
        
        NSLog(@"endpoint = %@", _endpoint);
        
        NSURL *url = [NSURL URLWithString:_endpoint];

        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *fetchDataTask = [session dataTaskWithRequest:request
                                                         completionHandler:
            ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                   
                if (error == nil) {
    
                    NSError *serializationError = nil;
                    
                    id jsonObjects = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&serializationError];
                    
                    if(serializationError != nil) {
                        NSLog(@"Error: %@", serializationError.description);
                    }

                    NSArray *results = (NSArray *)jsonObjects;

                    if([results count] > 0) {

                        [_dataSource addObjectsFromArray:results];
                        _isPageRefreshing = NO;

                        [self performSelectorOnMainThread:@selector(refreshTableViewData) withObject:nil waitUntilDone:NO];
                    }
                }
        }];
        
        [fetchDataTask resume];
    }
}

- (void)refreshTableViewData {
    [_tableView reloadData];
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        if(_isPageRefreshing == NO && _page >= 0) {
            _isPageRefreshing = YES;

            [self loadDataSourceWithEndPoint:_endpoint page:_page++];
            [self refreshTableViewData];

            NSLog(@"page = %d", _page);
        }
    }
}
*/

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *identifier = @"Item";
    
    ListItem *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell != nil) {
        cell = [[ListItem alloc] initWithMemberData:[_dataSource objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections
    if (_dataSource && [_dataSource count] > 0) {
        [_tableView setBackgroundView:nil];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        return 1;
    }
    else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [messageLabel setText:NSLocalizedString(@"NoDataYet", nil)];
        [messageLabel setTextColor:[UIColor blackColor]];
        [messageLabel setNumberOfLines:0];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel sizeToFit];
        
        [_tableView setBackgroundView:messageLabel];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
