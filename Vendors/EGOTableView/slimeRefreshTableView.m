//
//  slimeRefreshTableView.m
//  simleRefresh
//
//  Created by ZYW on 14/7/5.
//  Copyright (c) 2014年 ZYW. All rights reserved.
//

#import "slimeRefreshTableView.h"

@interface slimeRefreshTableView (Private) <UIScrollViewDelegate>
- (void)config;
- (void)configDisplayProperties;
@end

@implementation slimeRefreshTableView

- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
        headRefresh:(BOOL)head
        footRefresh:(BOOL)foot
{
    self = [super initWithFrame:frame
                          style:style];
    if (self) {
        [self configHaveHeadRefresh:head
                    haveFootRefresh:foot];
    }
    
    return self;
}


- (void) configHaveHeadRefresh:(BOOL)head
               haveFootRefresh:(BOOL)foot
{
    delegateInterceptor = [[MessageInterceptor alloc] init];
    delegateInterceptor.middleMan = self;
    delegateInterceptor.receiver = self.delegate;
    super.delegate = (id)delegateInterceptor;

    _pullTableIsRefreshing = NO;
    _pullTableIsLoadingMore = NO;
    
    if (head) {
        UIColor *skinColor = RGB(0, 0, 0);
        slimeView = [[SRRefreshView alloc] init];
        slimeView.delegate = self;
        slimeView.upInset = 0;
        slimeView.slimeMissWhenGoingBack = YES;
        slimeView.slime.bodyColor = skinColor;
        slimeView.slime.lineWith = 1;
        slimeView.slime.shadowBlur = 4;
        [self addSubview:slimeView];
    }
    
    if (foot) {
        loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height,
                                                                                 self.bounds.size.width,
                                                                                 self.bounds.size.height)];
        loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
      
        loadMoreView.delegate = self;
        [self addSubview:loadMoreView];
    }
}


# pragma mark - View changes

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat visibleTableDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height) - _footHspaceHeight);
    
    CGRect loadMoreFrame = loadMoreView.frame;
    loadMoreFrame.origin.y = self.contentSize.height + visibleTableDiffBoundsHeight;
    loadMoreView.frame = loadMoreFrame;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if(delegateInterceptor) {
        super.delegate = nil;
        delegateInterceptor.receiver = delegate;
        super.delegate = (id)delegateInterceptor;
    } else {
        super.delegate = delegate;
    }
}


- (void)reloadData
{
    [super reloadData];
    [loadMoreView egoRefreshScrollViewDidScroll:self];
}

- (void)setIsNeedRefreshHead:(BOOL)isNeedRefreshHead
{
	if (isNeedRefreshHead && !slimeView) {
		UIColor *skinColor = RGB(0, 0, 0);
		slimeView = [[SRRefreshView alloc] init];
		slimeView.delegate = self;
		slimeView.upInset = 0;
		slimeView.slimeMissWhenGoingBack = YES;
		slimeView.slime.bodyColor = skinColor;
		slimeView.slime.lineWith = 1;
		slimeView.slime.shadowBlur = 4;
		[self addSubview:slimeView];
	}else{
		[slimeView removeFromSuperview];
	}
}

- (void)setIsNeedRefreshMore:(BOOL)isLoadingMore
{
	if (isLoadingMore && !loadMoreView) {
		loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height,
																				 self.bounds.size.width,
																				 self.bounds.size.height)];
		loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		
		
		loadMoreView.delegate = self;
		[self addSubview:loadMoreView];
	}else{
		[loadMoreView removeFromSuperview];
	}
}

- (void)setPullTableIsRefreshing:(BOOL)isRefreshing
{
	if(!_pullTableIsRefreshing && isRefreshing) {
		[slimeView scrollViewDidScroll];
		_pullTableIsRefreshing = YES;
	} else if(_pullTableIsRefreshing && !isRefreshing) {
		[slimeView endRefresh];
		_pullTableIsRefreshing = NO;
	}
}


- (void)setPullTableIsLoadingMore:(BOOL)isLoadingMore
{
	if(!_pullTableIsLoadingMore && isLoadingMore) {
		[loadMoreView startAnimatingWithScrollView:self];
		_pullTableIsLoadingMore = YES;
	} else if(_pullTableIsLoadingMore && !isLoadingMore) {
		[loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
		_pullTableIsLoadingMore = NO;
	}
}




- (void)configDisplayProperties
{
    [loadMoreView setBackgroundColor:self.pullBackgroundColor
                           textColor:self.pullTextColor
                          arrowImage:nil];
}

#pragma mark - Display properties

- (void)setPullArrowImage:(UIImage *)aPullArrowImage
{
    if(aPullArrowImage != _pullArrowImage) {
        _pullArrowImage = aPullArrowImage;
        [self configDisplayProperties];
    }
}

- (void)setPullBackgroundColor:(UIColor *)aColor
{
    if(aColor != _pullBackgroundColor) {
        _pullBackgroundColor = aColor;
        [self configDisplayProperties];
    }
}

- (void)setPullTextColor:(UIColor *)aColor
{
    if(aColor != _pullTextColor) {
        _pullTextColor = aColor;
        [self configDisplayProperties];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [slimeView scrollViewDidScroll];
    
    [loadMoreView egoRefreshScrollViewDidScroll:scrollView];
    
    if ([delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [slimeView scrollViewDidEndDraging];
    
    [loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if ([delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [delegateInterceptor.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [delegateInterceptor.receiver scrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - SRRefreshDelegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    _pullTableIsRefreshing = YES;
    [_pullDelegate pullTableViewDidTriggerRefresh:self];
}


#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    _pullTableIsLoadingMore = YES;
    [_pullDelegate pullTableViewDidTriggerLoadMore:self];
}


@end
