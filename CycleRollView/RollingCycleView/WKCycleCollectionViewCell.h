//
//  WKCycleCollectionViewCell.h
//  CycleRollView
//
//  Created by celink on 15/11/3.
//  Copyright © 2015年 celink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCycleCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak)UIImageView* imageView;
@property(nonatomic, copy)NSString* title;

@property(nonatomic, strong)UIColor* titleLabelTextColor;
@property(nonatomic, strong)UIFont* titleLabelTextFont;
@property(nonatomic, strong)UIColor* titleLabelBackgroundColor;
@property(nonatomic, assign)CGFloat titleLabelHeight;

@property(nonatomic, assign)CGFloat imageViewMinX;
@property(nonatomic, assign)CGFloat imageViewMinY;

@property(nonatomic,assign)BOOL hasConfigured;


@end
