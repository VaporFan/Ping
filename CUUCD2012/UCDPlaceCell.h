//
//  UCDPlaceCell.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDTableViewCell.h"
#import "UCDBorderedLabel.h"
#import "UCDPopularityView.h"

@interface UCDPlaceCell : UCDTableViewCell

@property (nonatomic, strong) UCDBorderedLabel *distanceLabel;
@property (nonatomic, strong) UCDPopularityView *popularityView;

@end
