//
//  ImageShareController.h
//  qmp_ios
//
//  Created by QMP on 2018/3/12.
//  Copyright © 2018年 Molly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedPlatform)(ShareType shareType);

@interface ImageShareController : UIViewController

@property(nonatomic,strong) UIImage *image;

+(ImageShareController*)showShareViewWithImage:(UIImage*)shareImg didTapPlatform:(SelectedPlatform)selectPlayform;

@end