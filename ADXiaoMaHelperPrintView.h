//
//  ADXiaoMaHelperPrintView.h
//  anbang_ios
//
//  Created by 王奥东 on 17/7/15.
//  Copyright © 2017年 ch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADXiaoMaBangHelperModel;

typedef void(^printViewBlock)(ADXiaoMaBangHelperModel *model);

@interface ADXiaoMaHelperPrintView : UIView

@property(nonatomic, copy)printViewBlock printBlock;

@property (nonatomic,strong)    UITextView *textView;


@end
