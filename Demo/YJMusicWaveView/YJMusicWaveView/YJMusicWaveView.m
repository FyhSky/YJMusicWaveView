//
//  YJMusicWaveView.m
//  YJMusicWaveView
//
//  Created by YangJing on 2018/4/28.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "YJMusicWaveView.h"

@interface YJMusicWaveView () <UIScrollViewDelegate>

@end

@implementation YJMusicWaveView {
    UIScrollView *_backScrollView;
    UIScrollView *_scrollView;
    
    CALayer *_maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubview];
    }
    return self;
}

//MARK: - private methods
- (void)startAnimation {
    
    NSLog(@"yangjing_test: %.2f", _scrollView.contentOffset.x);
    
    [_maskLayer removeAllAnimations];
    [_maskLayer removeFromSuperlayer];
    
    UIImage *image3 = [UIImage imageNamed:@"pic_yinlang_blue"];
    _maskLayer = [CALayer new];
    _maskLayer.frame = CGRectMake(-(_scrollView.contentOffset.x)/2, 0, _scrollView.contentOffset.x, 50);
    _maskLayer.anchorPoint = CGPointMake(0, 0.5);//单独使用bounds动画，大小改变，中心点不变，需要调整锚点使蒙层的锚点在(0,0.5)位置（默认锚点为(0.5, 0.5)）
    _maskLayer.backgroundColor = [UIColor colorWithPatternImage:image3].CGColor;//这种方法绘制背景色比较耗内存，图片尽量小点
    [_scrollView.layer addSublayer:_maskLayer];
    
    CABasicAnimation *widthAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    widthAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _scrollView.contentOffset.x, 50)];
    widthAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _scrollView.contentOffset.x+self.bounds.size.width-40, 50)];
    widthAnimation.duration = 60;
    widthAnimation.repeatCount = HUGE_VALF; //无限循环
    [_maskLayer addAnimation:widthAnimation forKey:@"coverScroll"];
}

- (void)stopAnimation {
    [_maskLayer removeAllAnimations];
    [_maskLayer removeFromSuperlayer];
}

//MARK: - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //scrollView联动
    if ([scrollView isEqual:_scrollView]) {
        _backScrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x-20, _scrollView.contentOffset.y) ;
        
        [self stopAnimation];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startAnimation];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self startAnimation];
    }
}

- (void)configSubview {
    UIImage *image = [UIImage imageNamed:@"pic_yinlang_gray"];
    _backScrollView = [[UIScrollView alloc] init];
    [self addSubview:_backScrollView];
    _backScrollView.userInteractionEnabled = NO;
    _backScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
    _backScrollView.contentSize = CGSizeMake(self.bounds.size.width*2, 0);
    _backScrollView.backgroundColor = [UIColor colorWithPatternImage:image];//这种方法绘制背景色比较耗内存，图片尽量小点
    _backScrollView.contentOffset = CGPointMake(-20, 0);
    
    UIImage *image2 = [UIImage imageNamed:@"pic_yinlang_white"];
    _scrollView = [[UIScrollView alloc] init];
    [self addSubview:_scrollView];
    _scrollView.frame = CGRectMake(20, 0, self.bounds.size.width-40, 50);
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width*2, 0);
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:image2];//这种方法绘制背景色比较耗内存，图片尽量小点
    _scrollView.delegate = self;
}



@end
