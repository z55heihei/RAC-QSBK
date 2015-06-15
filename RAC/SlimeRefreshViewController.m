//
//  SlimeRefreshViewController.m
//  SnapWine
//
//  Created by ZYW on 14/7/5.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#import "SlimeRefreshViewController.h"

@interface SlimeRefreshViewController ()
{
    int currentMaxDisplayedCell;
    int currentMaxDisplayedSection;
}

@end

@implementation SlimeRefreshViewController

@synthesize cellZoomXScaleFactor = _xZoomFactor;
@synthesize cellZoomYScaleFactor = _yZoomFactor;
@synthesize cellZoomAnimationDuration = _animationDuration;
@synthesize cellZoomInitialAlpha = _initialAlpha;
@synthesize slimeTableView = _slimeTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)requestHeadData
{
  //do something
}

- (void)requestFootData
{
  //do something
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(slimeRefreshTableView *)pullTableView
{
    [self performSelector:@selector(requestHeadData)
               withObject:nil
               afterDelay:0.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(slimeRefreshTableView *)pullTableView
{
    [self performSelector:@selector(requestFootData)
               withObject:nil
               afterDelay:0.5f];
}

- (void)requestHeadStop
{
    self.slimeTableView.pullTableIsRefreshing = NO;
}


- (void)requestFootStop
{
    self.slimeTableView.pullTableIsLoadingMore = NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOpenZoonAnimtion) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if ((indexPath.section == 0 && currentMaxDisplayedCell == 0) || indexPath.section > currentMaxDisplayedSection){ //first item in a new section, reset the max row count
                currentMaxDisplayedCell = -1; //-1 because the check for currentMaxDisplayedCell has to be > rather than >= (otherwise the last cell is ALWAYS animated), so we need to set this to -1 otherwise the first cell in a section is never animated.
            }
            
            if (indexPath.section >= currentMaxDisplayedSection && indexPath.row > currentMaxDisplayedCell){ //this check makes cells only animate the first time you view them (as you're scrolling down) and stops them re-animating as you scroll back up, or scroll past them for a second time.
                
                //now make the image view a bit bigger, so we can do a zoomout effect when it becomes visible
                
                cell.contentView.alpha = self.cellZoomInitialAlpha.floatValue;
                
                CGAffineTransform transformScale = CGAffineTransformMakeScale(self.cellZoomXScaleFactor.floatValue, self.cellZoomYScaleFactor.floatValue);
                CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(self.cellZoomXOffset.floatValue, self.cellZoomYOffset.floatValue);
                
                cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
                
                [self.slimeTableView bringSubviewToFront:cell.contentView];
                [UIView animateWithDuration:self.cellZoomAnimationDuration.floatValue
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                                     cell.contentView.alpha = 1;
                                     //clear the transform
                                     cell.contentView.transform = CGAffineTransformIdentity;
                                 } completion:nil];
                
                
                currentMaxDisplayedCell = indexPath.row;
                currentMaxDisplayedSection = indexPath.section;
            }
        });
    }
}

- (void)resetViewedCells
{
    currentMaxDisplayedSection = 0;
    currentMaxDisplayedCell = 0;
}

#pragma -mark Setters for four customisable variables
- (void)setCellZoomXScaleFactor:(NSNumber *)xZoomFactor
{
    _xZoomFactor = xZoomFactor;
}

- (void)setCellZoomYScaleFactor:(NSNumber *)yZoomFactor
{
    _yZoomFactor = yZoomFactor;
}

- (void)setCellZoomAnimationDuration:(NSNumber *)animationDuration
{
    _animationDuration = animationDuration;
}

- (void)setCellZoomInitialAlpha:(NSNumber *)initialAlpha
{
    _initialAlpha = initialAlpha;
}

#pragma -mark Getters for four customisable variable. Provide default if not set.

- (NSNumber *)cellZoomXScaleFactor
{
    if (_xZoomFactor == nil){
        _xZoomFactor = [NSNumber numberWithFloat:1.25];
    }
    return _xZoomFactor;
}

- (NSNumber *)cellZoomXOffset
{
    if (_cellZoomXOffset == nil){
        _cellZoomXOffset = [NSNumber numberWithFloat:0];
    }
    return _cellZoomXOffset;
}

- (NSNumber *)cellZoomYOffset
{
    if (_cellZoomYOffset == nil){
        _cellZoomYOffset = [NSNumber numberWithFloat:0];
    }
    return _cellZoomYOffset;
}

- (NSNumber *)cellZoomYScaleFactor
{
    if (_yZoomFactor == nil){
        _yZoomFactor = [NSNumber numberWithFloat:1.25];
    }
    return _yZoomFactor;
}

- (NSNumber *)cellZoomAnimationDuration
{
    if (_animationDuration == nil){
        _animationDuration = [NSNumber numberWithFloat:0.65];
    }
    return _animationDuration;
}

- (NSNumber *)cellZoomInitialAlpha
{
    if (_initialAlpha == nil){
        _initialAlpha = [NSNumber numberWithFloat:0.3];
    }
    return _initialAlpha;
}





@end
