//
//  MovieCell.h
//  flixster
//
//  Created by Roesha Nigos on 6/28/18.
//  Copyright © 2018 Roesha Nigos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
//public
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;


@end
