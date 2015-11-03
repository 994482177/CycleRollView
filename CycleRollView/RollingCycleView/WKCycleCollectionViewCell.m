//
//  WKCycleCollectionViewCell.m
//  CycleRollView
//
//  Created by celink on 15/11/3.
//  Copyright © 2015年 celink. All rights reserved.
//

#import "WKCycleCollectionViewCell.h"

@implementation WKCycleCollectionViewCell
{
    __weak UILabel* _titleLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setupImageView];
        [self setupTitleLabel];
    }
    return self;
}

-(void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelTextColor=titleLabelBackgroundColor;
    _titleLabel.backgroundColor=titleLabelBackgroundColor;
}
-(void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor=titleLabelTextColor;
    _titleLabel.textColor=titleLabelTextColor;
}
- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
}
-(void)setImageViewMinX:(CGFloat)imageViewMinX
{
    _imageViewMinX=imageViewMinX;
    _imageView.frame=CGRectMake(_imageViewMinX, _imageViewMinY, CGRectGetWidth(self.frame)-_imageViewMinX*2, CGRectGetHeight(self.frame)-_imageViewMinY);
}
-(void)setImageViewMinY:(CGFloat)imageViewMinY
{
    _imageViewMinY=imageViewMinY;
    _imageView.frame=CGRectMake(_imageViewMinX, _imageViewMinY, CGRectGetWidth(self.frame)-_imageViewMinX*2, CGRectGetHeight(self.frame)-_imageViewMinY);
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    _imageView.frame = self.bounds;
    [self addSubview:imageView];
}
- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self addSubview:titleLabel];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleLabelW = self.bounds.size.width-_imageViewMinX*2;
    CGFloat titleLabelH = _titleLabelHeight;
    CGFloat titleLabelX = _imageViewMinX;
    CGFloat titleLabelY = self.bounds.size.height - titleLabelH;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.hidden = !_titleLabel.text;
}

@end
