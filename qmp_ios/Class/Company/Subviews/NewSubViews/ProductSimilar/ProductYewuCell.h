//
//  ProductYewuCell.h
//  qmp_ios
//
//  Created by QMP on 2018/8/6.
//  Copyright © 2018年 Molly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductYewuCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView*)tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end