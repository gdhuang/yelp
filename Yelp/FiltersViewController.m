//
//  FiltersViewController.m
//  Yelp
//
//  Created by GD Huang on 6/21/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()


@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL isDeals;
@property (nonatomic) BOOL isRadiusCollapsed;
@property (nonatomic) BOOL isSortingCollapsed;

@property (nonatomic, strong) NSArray *radius;
@property (nonatomic, strong) NSArray *radiusInMeter;
@property (nonatomic) int selectedRadius;

@property (nonatomic, strong) NSArray *sorting;
@property (nonatomic) int selectedSorting;


@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

- (void) initCategories;
@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isDeals = NO;
        self.isRadiusCollapsed = YES;
        self.isSortingCollapsed = YES;
        self.selectedCategories = [NSMutableSet set];
        
        
        self.radius =  [NSArray arrayWithObjects: @"1km", @"5km", @"10km", @"25km", nil];
        self.radiusInMeter =  [NSArray arrayWithObjects:
                               [NSNumber numberWithInt:1000],
                               [NSNumber numberWithInt:5000],
                               [NSNumber numberWithInt:10000],
                               [NSNumber numberWithInt:25000],
                               nil];
        self.selectedRadius = 3;
        
        self.sorting =  [NSArray arrayWithObjects: @"Best matched", @"Distance", @"Highest Rated", nil];
        self.selectedRadius = 0;
        
        [self initCategories];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target: self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target: self action:@selector(onApplyButton)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DropDownCell" bundle:nil] forCellReuseIdentifier:@"DropDownCell"];
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


#pragma mark - Private methods

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    

    [filters setObject:self.radiusInMeter[self.selectedRadius] forKey:@"radius_filter"];
    [filters setObject:[NSNumber numberWithInt:self.selectedSorting] forKey:@"sort"];
    [filters setObject:[NSNumber numberWithBool:self.isDeals] forKey:@"deals_filter"];
    
    if(self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *category in self.selectedCategories){
            [names addObject:category[@"code"]];
            
        }
        NSString *categoryfilter = [names componentsJoinedByString:@","];
        
        [filters setObject:categoryfilter forKey:@"category_filter"];
    }
    
    
    return filters;
}

- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) initCategories {
    self.categories = @[@{@"name" : @"Afghan", @"code": @"afghani" },
                        @{@"name" : @"African", @"code": @"african" },
                        @{@"name" : @"American, New", @"code": @"newamerican" },
                        @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                        @{@"name" : @"Arabian", @"code": @"arabian" },
                        @{@"name" : @"Argentine", @"code": @"argentine" },
                        @{@"name" : @"Armenian", @"code": @"armenian" },
                        @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                        @{@"name" : @"Asturian", @"code": @"asturian" },
                        @{@"name" : @"Australian", @"code": @"australian" },
                        @{@"name" : @"Austrian", @"code": @"austrian" },
                        @{@"name" : @"Baguettes", @"code": @"baguettes" },
                        @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
                        @{@"name" : @"Barbeque", @"code": @"bbq" },
                        @{@"name" : @"Basque", @"code": @"basque" },
                        @{@"name" : @"Bavarian", @"code": @"bavarian" },
                        @{@"name" : @"Beer Garden", @"code": @"beergarden" },
                        @{@"name" : @"Beer Hall", @"code": @"beerhall" },
                        @{@"name" : @"Beisl", @"code": @"beisl" }];
    
}



#pragma mark - table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.isRadiusCollapsed) {
            //collapsed -> expand
            
        } else {
            //expand -> collapsed
            self.selectedRadius = indexPath.row;
        }
        self.isRadiusCollapsed = !self.isRadiusCollapsed;
    } else if(indexPath.section == 2) {
        if (self.isSortingCollapsed) {
            //expand
        } else {
            //collapsed
            self.selectedSorting = indexPath.row;
        }
        self.isSortingCollapsed = !self.isSortingCollapsed;
    }
        
    ///reload this section
    [self.tableView reloadData];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0) {
        return 1;
    } else if(section==1) {
        if (self.isRadiusCollapsed) {
            return 1;
        } else {
            return 4;
        }
    } else if(section==2) {
        if (self.isSortingCollapsed) {
            return 1;
        } else {
            return 3;
        }
    } else if(section==3) {
        return self.categories.count;
    }
    return 0;

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"Distance";
            break;
        case 2:
            return @"Sorted By";
            break;
        case 3:
            return @"Category";
            break;
        default:
            return @"";
            break;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return [self buildDealsCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 1:
            return [self buildRadiusCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 2:
            return [self buildSortingCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 3:
            return [self buildCategoryCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        default:
            return nil;
            break;
    };
}



- (UITableViewCell *) buildDealsCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = @"Offering a Deal";
    cell.on = self.isDeals;
    
    cell.delegate = self;
    
    return cell;
}

- (UITableViewCell *) buildRadiusCell:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.isRadiusCollapsed) {
        UIImage *btnImage = [UIImage imageNamed:@"dropdown.png"];
        
        DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
        cell.titleLabel.text = self.radius[self.selectedRadius];
        [cell.dropDownButton setBackgroundImage:btnImage forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    }
    else {
        DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
        cell.titleLabel.text = self.radius[indexPath.row];
        [cell.dropDownButton setBackgroundImage:nil forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    }
}


- (UITableViewCell *) buildSortingCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isSortingCollapsed) {
        UIImage *btnImage = [UIImage imageNamed:@"dropdown.png"];
        
        DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
        cell.titleLabel.text = self.sorting[self.selectedSorting];
        [cell.dropDownButton setBackgroundImage:btnImage forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    }
    else {
        DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
        cell.titleLabel.text = self.sorting[indexPath.row];
        [cell.dropDownButton setBackgroundImage:nil forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    }
}

- (UITableViewCell *) buildCategoryCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    
    cell.delegate = self;
    
    return cell;
}

- (void) switchCell:(SwitchCell*)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.section) {
        case 0:
            self.isDeals = value;
            break;
        case 3:
            if(value){
                [self.selectedCategories addObject:self.categories[indexPath.row]];
            }
            else {
                [self.selectedCategories removeObject:self.categories[indexPath.row]];
            }
        default:
            break;
    };
    
}

- (void) dropDownCell:(DropDownCell*)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

@end
