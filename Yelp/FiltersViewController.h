//
//  FiltersViewController.h
//  Yelp
//
//  Created by GD Huang on 6/21/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCell.h"
#import "DropDownCell.h"


@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void) filtersViewController:(FiltersViewController*) filtersViewController didChangeFilters:(NSDictionary*) filters;

@end


@interface FiltersViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, DropDownCellDelegate>


@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;



@end
