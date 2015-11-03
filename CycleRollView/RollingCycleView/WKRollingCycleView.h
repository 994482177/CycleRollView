//
//  WKRollingCycleView.h
//  7dmallStore
//
//  Created by celink on 15/9/11.
//  Copyright (c) 2015年 celink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageTapBlock)(id obj, NSInteger index);

@interface WKRollingCycleView : UIView

@property(nonatomic, weak)UICollectionView* mainView;   //主体内容滚动视图

@property(nonatomic, strong)NSArray* imageStringArray;  //图片的URL
@property (nonatomic, strong) NSArray *titlesGroup;     //每张图片对应要显示的文字数组

@property(nonatomic, assign)CGFloat  pageViewMinY;      //距离图片的位置
@property(nonatomic, assign)CGFloat  pageViewMaxX;      //距离右边框的位置

@property(nonatomic, assign)CGFloat  imageBorderWidth;  //图片的边框
@property(nonatomic, strong)UIColor* imageBorderColor;  //图片的边框颜色

@property(nonatomic, assign)CGFloat imageMinY;          //图片距离上边框的距离
@property(nonatomic, assign)CGFloat imageMinX;          //图片距离右边的距离

//文字设置
@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont  *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;


@property(nonatomic, assign)CGFloat  rollingTimeInterval;//滚动时间

-(instancetype)initWithFrame:(CGRect)frame callBack:(ImageTapBlock)callBackBlock;

@end
