//
//  SuggestionsViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "GCPlaceholderTextView.h"

@interface SuggestionsViewController : BaseViewController

@property (nonatomic, strong) GCPlaceholderTextView *suggestionTextView;
@property (nonatomic, strong) UIButton *btnFinish;
@end
