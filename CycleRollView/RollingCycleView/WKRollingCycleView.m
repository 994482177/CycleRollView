//
//  WKRollingCycleView.m
//  7dmallStore
//
//  Created by celink on 15/9/11.
//  Copyright (c) 2015年 celink. All rights reserved.
//

#import "WKRollingCycleView.h"
#import "UIImageView+WebCache.h"
#import "WKCycleCollectionViewCell.h"

@interface WKRollingCycleView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, weak)NSTimer* time;


@property(nonatomic, weak)  UICollectionViewFlowLayout* flowLayout;
@property(nonatomic, strong)UIPageControl* pageView;
@property(nonatomic, assign)NSInteger  currentPage;
@property(nonatomic, assign)NSInteger  pageNum;
@property(nonatomic, assign)NSInteger  totalItemCount;


@property(nonatomic, copy)ImageTapBlock tempBlock;

@end

@implementation WKRollingCycleView

- (instancetype)initWithFrame:(CGRect)frame callBack:(ImageTapBlock)callBackBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _tempBlock=callBackBlock;
        [self createUI];
    }
    return self;
}
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [_time invalidate];
        _time = nil;
    }
}
//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}


-(void)createUI
{
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont systemFontOfSize:14];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _pageViewMinY=10;
    
    UICollectionViewFlowLayout* flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize=self.frame.size;
    flowLayout.minimumLineSpacing=0;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _flowLayout=flowLayout;
    
    UICollectionView* mainView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.pagingEnabled=YES;
    mainView.backgroundColor=[UIColor clearColor];
    mainView.showsVerticalScrollIndicator=NO;
    mainView.showsHorizontalScrollIndicator=NO;
    [mainView registerClass:[WKCycleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    mainView.dataSource=self;
    mainView.delegate=self;
    [self addSubview:mainView];
    _mainView=mainView;
    
    _imageBorderColor=[UIColor whiteColor];
    
    self.pageView=[[UIPageControl alloc]init];
    self.pageView.frame=CGRectMake(0, CGRectGetHeight(self.frame)-10, CGRectGetWidth(self.frame), 10);
    self.pageView.currentPage=0;
    self.pageView.pageIndicatorTintColor=[UIColor whiteColor];
    self.pageView.currentPageIndicatorTintColor=[UIColor orangeColor];
    [self addSubview:self.pageView];
}
#pragma mark setProperty
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _flowLayout.itemSize = self.frame.size;
}

-(void)setImageStringArray:(NSArray *)imageStringArray
{
    _imageStringArray=imageStringArray;
    self.pageNum=self.imageStringArray.count;
    self.totalItemCount=self.pageNum*4;
    self.pageView.numberOfPages=self.pageNum;
    [self.mainView reloadData];
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.totalItemCount*0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
-(void)setRollingTimeInterval:(CGFloat)rollingTimeInterval
{
    _rollingTimeInterval=rollingTimeInterval;
    _time= [NSTimer scheduledTimerWithTimeInterval:rollingTimeInterval target:self selector:@selector(timeEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_time forMode:NSRunLoopCommonModes];
}
-(void)setPageViewMinY:(CGFloat)pageViewMinY
{
    _pageViewMinY=pageViewMinY;
    if (self.pageViewMaxX)
    {
        self.pageView.frame=CGRectMake(CGRectGetWidth(self.frame)-self.pageViewMaxX-16*self.pageNum, CGRectGetHeight(self.frame)-self.pageViewMinY, 16*self.pageNum, 10);
    }
    else
    {
        self.pageView.frame=CGRectMake(0, CGRectGetHeight(self.frame)-self.pageViewMinY,CGRectGetWidth(self.frame), 10);
    }
    
}
-(void)setPageViewMaxX:(CGFloat)pageViewMaxX
{
    _pageViewMaxX=pageViewMaxX;
    self.pageView.frame=CGRectMake(CGRectGetWidth(self.frame)-self.pageViewMaxX-16*self.pageNum, CGRectGetHeight(self.frame)-self.pageViewMinY, 16*self.pageNum, 10);
}
-(void)setImageBorderWidth:(CGFloat)imageBorderWidth
{
    _imageBorderWidth=imageBorderWidth;
}
-(void)setImageBorderColor:(UIColor *)imageBorderColor
{
    _imageBorderColor=imageBorderColor;
}
-(void)setImageMinY:(CGFloat)imageMinY
{
    _imageMinY=imageMinY;
}
-(void)setImageMinX:(CGFloat)imageMinX
{
    _imageMinX=imageMinX;
}



#pragma mark  定时 循环滚动逻辑：
-(void)timeEvent
{
    if (0 == _totalItemCount) return;
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    if (targetIndex == _totalItemCount-1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35*NSEC_PER_SEC)), dispatch_get_main_queue(), ^
           {
               [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemCount * 0.5-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
           });
    }
}
#pragma mark  ScrollView Delegate：
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.time invalidate];
    self.time=nil;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _time= [NSTimer scheduledTimerWithTimeInterval:_rollingTimeInterval target:self selector:@selector(timeEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_time forMode:NSRunLoopCommonModes];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex=(scrollView.contentOffset.x+self.mainView.bounds.size.width*0.5)/self.mainView.bounds.size.width;
    if (!self.imageStringArray.count)
    {
        return;
    }
    int indexOnPageControl=itemIndex%self.pageNum;
    _pageView.currentPage=indexOnPageControl;
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemCount;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKCycleCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    long itemIndex=indexPath.item%self.pageNum;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageStringArray[itemIndex]] placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRetryFailed];
    cell.title=self.titlesGroup[itemIndex];
    
    if (!cell.hasConfigured)
    {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.titleLabelTextColor = self.titleLabelTextColor;
        cell.titleLabelTextFont = self.titleLabelTextFont;
        cell.imageViewMinY=self.imageMinY;
        cell.imageViewMinX=self.imageMinX;
        cell.hasConfigured = YES;
        cell.imageView.layer.borderWidth=self.imageBorderWidth;
        cell.imageView.layer.borderColor=self.imageBorderColor.CGColor;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    long itemIndex=indexPath.item%self.pageNum;
    if (self.tempBlock)
    {
        self.tempBlock(nil, itemIndex);
    }
}

@end
