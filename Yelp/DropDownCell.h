//
//  DropDownCell.h
//  Yelp
//
//  Created by GD Huang on 6/22/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownCell;

@protocol DropDownCellDelegate <NSObject>

- (void) dropDownCell:(DropDownCell*)cell;

@end

@interface DropDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

@property (nonatomic, weak) id<DropDownCellDelegate> delegate;
- (IBAction)dropDownClicked:(id)sender;

@end
