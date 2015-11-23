//
//  DARecycledScrollView.h
//  DARecycledScrollViewDemo
//
//  Created by Daria Kopaliani on 6/21/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"

@class DARecycledScrollView, DARecycledTileView;
@protocol DARecycledScrollViewDataSource <NSObject>

- (NSInteger)numberOfTilesInScrollView:(DARecycledScrollView *)scrollView;
- (void)recycledScrollView:(DARecycledScrollView *)scrollView configureTileView:(DARecycledTileView *)tileView forIndex:(NSUInteger)index;
- (DARecycledTileView *)tileViewForRecycledScrollView:(DARecycledScrollView *)scrollView;
- (CGFloat)widthForTileAtIndex:(NSInteger)index scrollView:(DARecycledScrollView *)scrollView;

@end


@interface DARecycledScrollView : CustomScrollView

@property (assign, nonatomic) BOOL infinite;
@property (weak, nonatomic) id<DARecycledScrollViewDataSource> dataSource;
@property (assign, nonatomic) int pageNum;

- (DARecycledTileView *)dequeueRecycledTileView;
- (void)reloadData;
- (DARecycledTileView *)visibleTileViewForIndex:(NSUInteger)index;

@end