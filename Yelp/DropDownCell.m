//
//  DropDownCell.m
//  Yelp
//
//  Created by GD Huang on 6/22/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DropDownCell.h"

@implementation DropDownCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)dropDownClicked:(id)sender {
    [self.delegate dropDownCell:self];
}
@end
