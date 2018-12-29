//
//  StaffView.m
//  StaffDemo
//
//  Created by 罗树新 on 2018/12/24.
//  Copyright © 2018 罗树新. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffLineView.h"
#import "StaffPrivate.h"
#import "StaffModel.h"
#import "StaffContentView.h"
#import "StaffDetailView.h"

@interface StaffItemView ()
@property (nonatomic, strong) StaffLineView *widthLineView;
@property (nonatomic, strong) StaffLineView *heightLineView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *normalColor;
@end

@implementation StaffItemView

- (instancetype)init {
    if (self = [super init]) {
        self.mainColor = [UIColor redColor];
        self.normalColor = [UIColor colorWithRed:62.f/255 green:160.f/255 blue:227.f/255 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:0.3];
        self.layer.borderColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 2;
        self.layer.shadowColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1].CGColor;
        self.layer.shadowRadius = 0.5;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.3;
        [self addSubview:self.widthLineView];
        [self addSubview:self.heightLineView];
        self.scale = 1;
    }
    return self;
}

- (void)showColor:(UIColor *)color {
    self.widthLineView.themeColor = color;
    self.heightLineView.themeColor = color;
}

- (void)setMain:(BOOL)main {
    _main = main;
    if (self.isMain) {
        [self showColor:self.mainColor];
    } else {
        [self showColor:self.normalColor];
    }
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    if (_contentView) {
        CGRect screenFrame = [[UIApplication sharedApplication].keyWindow convertRect:contentView.frame fromView:contentView.superview];
        self.frame = screenFrame;
        self.widthLineView.hidden = NO;
        self.heightLineView.hidden = NO;
        self.hidden = NO;
    } else {
        self.frame = CGRectZero;
        self.widthLineView.hidden = YES;
        self.heightLineView.hidden = YES;
        self.hidden = YES;
        self.widthLineView.frame = CGRectZero;
        self.heightLineView.frame = CGRectZero;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect referRect = self.frame;
    CGFloat superWidth = CGRectGetWidth(self.superview.bounds);
    CGFloat superHeight = CGRectGetHeight(self.superview.bounds);
    CGFloat width = CGRectGetWidth(referRect);
    CGFloat height = CGRectGetHeight(referRect);
    CGFloat space = 30;
    if (width > 0 && height > 0) {
        CGFloat minX = CGRectGetMinX(referRect);
        CGFloat maxX = CGRectGetMaxX(referRect);
        CGFloat minY = CGRectGetMinY(referRect);
        CGFloat maxY = CGRectGetMaxY(referRect);
        self.heightLineView.hidden = NO;
        if (minX <= space && maxX >= superWidth - space) {
            self.heightLineView.frame = CGRectMake(width - 5, 0, 1, height);
            [self.heightLineView showLength:height / self.scale atPosition:StaffLineViewDataPositionLeft];
        } else if (minX > space && maxX >= superWidth - space) {
            self.heightLineView.frame = CGRectMake(- 5, 0, 1, height);
            [self.heightLineView showLength:height / self.scale atPosition:StaffLineViewDataPositionLeft];
        } else {
            self.heightLineView.frame = CGRectMake(width + 5, 0, 1, height);
            [self.heightLineView showLength:height / self.scale atPosition:StaffLineViewDataPositionRight];
            
        }
        
        self.widthLineView.hidden = NO;
        if (minY <= space && maxY >= superHeight - space) {
            self.widthLineView.frame = CGRectMake(0, height - 5, width, 1);
            [self.widthLineView showLength:width / self.scale atPosition:StaffLineViewDataPositionTop];
            
        } else if (minY > space && maxY >= superHeight - space) {
            self.widthLineView.frame = CGRectMake(0, -5, width, 1);
            [self.widthLineView showLength:width / self.scale atPosition:StaffLineViewDataPositionTop];
            
        } else {
            self.widthLineView.frame = CGRectMake(0, height + 5, width, 1);
            [self.widthLineView showLength:width / self.scale atPosition:StaffLineViewDataPositionBottom];
        }
    } else {
        self.widthLineView.frame = CGRectZero;
        self.heightLineView.frame = CGRectZero;
        self.widthLineView.hidden = YES;
        self.heightLineView.hidden = YES;
    }
}

- (StaffLineView *)widthLineView {
    if (!_widthLineView) {
        _widthLineView = [StaffLineView lineWithType:StaffLineViewTypeSpace];
    }
    return _widthLineView;
}

- (StaffLineView *)heightLineView {
    if (!_heightLineView) {
        _heightLineView = [StaffLineView lineWithType:StaffLineViewTypeSpace];
    }
    return _heightLineView;
}

- (void)setScale:(CGFloat)scale {
    if (scale <= 0) {
        scale = 1;
    }
    _scale = scale;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end

@interface StaffViewController ()

@property (nonatomic, strong) NSArray *contentViews;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *thirdTapGestureRecognizer;

@property (nonatomic, strong) StaffDetailView *detailView;
@property (nonatomic, strong) StaffModel *staffModel;


@property (nonatomic, strong) StaffContentView *contentView;


@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    self.contentView.frame = UIScreen.mainScreen.bounds;
    [self.view addGestureRecognizer:self.singleTapGestureRecognizer];
    [self.view addGestureRecognizer:self.doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:self.thirdTapGestureRecognizer];
    [self.view addSubview:self.detailView];
    self.detailView.hidden = YES;
}

- (NSInteger)staffItemViewsCount {
    return self.contentViews.count;
}

- (void)cleanStaffItemViews {
    self.contentViews = [NSArray new];
    [self refrestCoverViews];
}

- (void)showStaffItemViewOnView:(UIView *)view {
    if (view == nil) {
        return;
    }
    NSMutableArray *mutableContentViews = self.contentViews.mutableCopy;
    
    if ([self.contentViews containsObject:view]) {
        [mutableContentViews removeObject:view];
    } else {
        if (self.contentViews.count >= 2) {
            [mutableContentViews removeLastObject];
            [mutableContentViews addObject:view];
        } else {
            [mutableContentViews addObject:view];
        }
    }
    
    self.contentViews = mutableContentViews.copy;
    [self refrestCoverViews];
}

- (void)swapMain {
    if (self.staffItemViewsCount == 2) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [temp addObject:self.contentViews.lastObject];
        [temp addObject:self.contentViews.firstObject];
        self.contentViews = temp.copy;
        [self refrestCoverViews];
    }
}

- (void)refrestCoverViews {
    [self.contentView layoutViews:self.contentViews completed:nil];
    [self.detailView layoutViews:self.contentViews];
}

- (void)singleTapGestureRecognizerAction:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint tapPointInView = [gestureRecognizer locationInView:self.view];
        CGPoint detailPoint = [self.view convertPoint:tapPointInView toView:self.detailView];

        if ([self.detailView hitTest:detailPoint withEvent:nil]) {
            NSLog(@"%skjanjsnjda");
        } else {
            UIView *view = [StaffPrivate fiterViewForPoint:tapPointInView];
            [StaffPrivate private_singleTapActionWithView:view];
        }
    }
}

- (void)doubleTapGestureRecognizerAction:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [StaffPrivate private_doubleTapAction];
    }
}

- (void)thirdTagGestureRecognizerAction:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if (self.contentViews.count > 0) {
            if(self.detailView.hidden) {
                self.detailView.hidden = NO;
                self.detailView.alpha = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.detailView.alpha = 1;
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.detailView.alpha = 0;
                } completion:^(BOOL finished) {
                    self.detailView.hidden = YES;
                }];
            }
        }
    }
}

- (NSArray *)contentViews {
    if (!_contentViews) {
        _contentViews = [[NSArray alloc] init];
    }
    return _contentViews;
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer {
    if (!_singleTapGestureRecognizer) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizerAction:)];
        _singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [_singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
        [_singleTapGestureRecognizer requireGestureRecognizerToFail:self.thirdTapGestureRecognizer];
    }
    return _singleTapGestureRecognizer;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerAction:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        [_doubleTapGestureRecognizer requireGestureRecognizerToFail:self.thirdTapGestureRecognizer];
    }
    return _doubleTapGestureRecognizer;
}

-  (UITapGestureRecognizer *)thirdTapGestureRecognizer {
    if (!_thirdTapGestureRecognizer) {
        _thirdTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdTagGestureRecognizerAction:)];
        _thirdTapGestureRecognizer.numberOfTapsRequired = 3;
    }
    return _thirdTapGestureRecognizer;
}

- (StaffDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[StaffDetailView alloc] init];
        _detailView.backgroundColor = [UIColor whiteColor];
        _detailView.layer.cornerRadius = 4;
        _detailView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
        _detailView.layer.shadowOpacity = 0.5;
        _detailView.layer.shadowRadius = 4;
        _detailView.layer.shadowOffset = CGSizeMake(0, 0);
        _detailView.clipsToBounds = false;
    }
    return _detailView;
}

- (StaffContentView *)contentView {
    if (!_contentView) {
        _contentView = [[StaffContentView alloc] init];
        _contentView.isReferScreen = YES;
    }
    return _contentView;
}
@end
