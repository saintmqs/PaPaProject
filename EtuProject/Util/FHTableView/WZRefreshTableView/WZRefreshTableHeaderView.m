//
//  WZRefreshTableHeaderView.m
//  TableViewPullLift
//
//  Created by zhe wang on 11-7-6.
//  Copyright 2011年 nasawz.com. All rights reserved.
//

#import "WZRefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:129.0/255.0f green:68/255.0f blue:24.0/255.0f alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface WZRefreshTableHeaderView (Private)
- (void)setState:(WZPullRefreshState)aState;
@end

@implementation WZRefreshTableHeaderView

@synthesize delegate=_delegate;



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImage.image = [UIImage imageNamed:@"bg_imagebg.png"];
        [self addSubview:bgImage];
        [bgImage release];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(60.0f, frame.size.height - 40.0f, 20.0f, 30.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"ArrowDown.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:WZPullRefreshNormal];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(wzRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate wzRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MM-dd HH:mm"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"WZRefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(WZPullRefreshState)aState{
	
	switch (aState) {
		case WZPullRefreshPulling:
			
			_statusLabel.text = (_loadingStr)?_loadingStr : @"释放以刷新...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case WZPullRefreshNormal:
			
			if (_state == WZPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = (_normalStr)?_normalStr : @"下拉可刷新...";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case WZPullRefreshLoading:
			
			_statusLabel.text = @"加载中...";
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)wzRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == WZPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(wzRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate wzRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == WZPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:WZPullRefreshNormal];
		} else if (_state == WZPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:WZPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)wzRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(wzRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate wzRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(wzRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate wzRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:WZPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)wzRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:WZPullRefreshNormal];
    
}

#pragma mark 强制更新时启动刷新代理
-(void)forceToRefresh:(UIScrollView *)aScrollView{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(wzRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate wzRefreshTableHeaderDataSourceIsLoading:self];
    }
    NSLog(@"scrollView.contentOffset.y:%f",aScrollView.contentOffset.y);
    if (!_loading) {
        
        if ([_delegate respondsToSelector:@selector(wzRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate wzRefreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:WZPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        aScrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [_normalStr release];
    [_loadingStr release];
    [super dealloc];
}


@end
