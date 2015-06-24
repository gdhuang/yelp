//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCellTableViewCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        [self fetchBusinessWithQuery:@"" params:nil];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCellTableViewCell" bundle:nil]
                    forCellReuseIdentifier:@"BusinessCellTableViewCell"];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = @"Yelp";
    

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,200,44)];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    // tap
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCellTableViewCell" forIndexPath:indexPath];
    cell.business = self.businesses[indexPath.row];
    return cell;
    
}

#pragma mark - Filter delegate methods

- (void) filtersViewController:(FiltersViewController*) filtersViewController didChangeFilters:(NSDictionary*) filters {
    
    [self fetchBusinessWithQuery:@"restuarants" params:filters];
    
}

#pragma mark - Private methods

- (void) onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc
                                  ] init];
    
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params {
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSDictionary *businessDictionary = response[@"businesses"];
        self.businesses = [Business businessWithDictionaries:businessDictionary];
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}

#pragma mark - searchbar methods



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    [self fetchBusinessWithQuery:searchText params:nil];
    [searchBar endEditing:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.navigationItem.titleView endEditing:YES];
}

@end
