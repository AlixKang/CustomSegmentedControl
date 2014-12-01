//
//  CustomSegmentedControl.m
//  CustomSegmentedControl
//
//  Created by Alix on 12/1/14.
//
//

#import "CustomSegmentedControl.h"

#define kStartTag   2014

#pragma mark - 
@interface UIView (frame)
@property (assign) CGFloat x;
@property (assign) CGFloat centerY;
@property (assign, readonly) CGFloat width;
@property (assign, readonly) CGFloat height;
@property (assign, readonly) CGFloat right;
@end
@implementation UIView (frame)
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)centerY{
    return self.frame.origin.y + self.frame.size.height * 0.5f;
}
- (void)setCenterY:(CGFloat)centerY{
    self.frame = CGRectMake(self.frame.origin.x, centerY - self.frame.size.height*0.5, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}
@end

#pragma mark -
@interface CustomSegmentedItem : UIControl
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) EImageLocation imageLocation;
@property (nonatomic, weak) CustomSegmentedControl *itemContainer;

@property (nonatomic, assign) CGFloat imageRotateRadians;

- (void)rotateImageWithAnimation:(BOOL)animated;
- (void)shouldHighlighted:(BOOL)highlighted;
- (CGFloat)imageRadians;
@end
@implementation CustomSegmentedItem

- (void)rotateImageWithAnimation:(BOOL)animated{
    NSTimeInterval duration = 0.0f;
    if (animated) {
        duration = 0.15f;
    }
    CGFloat radians = atan2f(_imageView.transform.b, _imageView.transform.a);
    
    if (radians == 0) {
        _imageRotateRadians = M_PI;
    } else {
        _imageRotateRadians = 0;
    }
    
    __weak __block CustomSegmentedItem *weakItem = self;
    [UIView animateWithDuration:duration animations:^{
        if (radians == 0) {
            weakItem.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            weakItem.imageView.transform = CGAffineTransformMakeRotation(0);
        }
    }  completion:^(BOOL finished) {
    }];

}
- (CGFloat)imageRadians{
    return _imageRotateRadians;
}
#pragma mark - override
- (UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        self.exclusiveTouch = YES;
    }
    return _imageView;
}
- (UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = _itemContainer.hightlightBackgroundColor;
        _titleLabel.highlighted = highlighted;
        _imageView.highlighted = highlighted;
    }
}

- (void)shouldHighlighted:(BOOL)highlighted{
    _titleLabel.highlighted = highlighted;
    _imageView.highlighted = highlighted;
    if (highlighted) {
        self.backgroundColor = _itemContainer.hightlightBackgroundColor;
    } else {
        self.backgroundColor = _itemContainer.normalBackgroundColor;
    }
}
- (void)setImageLocation:(EImageLocation)imageLocation{
    _imageLocation = imageLocation;
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_imageView sizeToFit];
    [_titleLabel sizeToFit];
    
    CGFloat left = self.width - _imageView.width - 5 - _titleLabel.width;
    
    if (_imageLocation == EImageAtRight) {
        _titleLabel.x = left * 0.5f;
        _imageView.x = _titleLabel.right + 5;
        
        _titleLabel.centerY = self.height * 0.5f;
        _imageView.centerY = _titleLabel.centerY;
    } else {
        _imageView.x = left * 0.5f;
        _titleLabel.x = _imageView.right + 5;
        
        _titleLabel.centerY = self.height * 0.5f;
        _imageView.centerY = _titleLabel.centerY;
    }
}

@end

#pragma mark -
@interface CustomSegmentedControl ()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isItemFirstSelected;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation CustomSegmentedControl
#pragma mark - private
- (void)setDefaults{
    _font = [UIFont systemFontOfSize:13.f];
    _normalBackgroundColor = [UIColor orangeColor];
    _hightlightBackgroundColor    = [UIColor purpleColor];
    
    _textColor = [UIColor blackColor];
    _highlightTextColor = [UIColor whiteColor];
    
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = _hightlightBackgroundColor;
        [self addSubview:_backgroundView];
    }
    self.exclusiveTouch = YES;
}
- (CustomSegmentedItem*)itemAtIndex:(NSUInteger)index{
    for (UIView *subview in self.subviews) {
        if (subview.tag == (index+kStartTag) && [subview isKindOfClass:CustomSegmentedItem.class]) {
            return (CustomSegmentedItem*)subview;
        }
    }
    return nil;
}

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}
- (void)setImageLocation:(EImageLocation)imageLocation{
    _imageLocation = imageLocation;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:CustomSegmentedItem.class]) {
            ((CustomSegmentedItem*)subview).imageLocation = _imageLocation;
        }
    }
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex == currentIndex) {
        _isItemFirstSelected = NO;
    } else {
        _isItemFirstSelected = YES;
    }
    _currentIndex = currentIndex;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = self.hightlightBackgroundColor.CGColor;
    _backgroundView.backgroundColor = self.hightlightBackgroundColor;
    _backgroundView.frame = self.bounds;
    [self sendSubviewToBack:_backgroundView];
}
- (void)setHightlightBackgroundColor:(UIColor *)hightlightBackgroundColor{
    _highlightTextColor = hightlightBackgroundColor;
    [self setNeedsLayout];
}
#pragma mark - public
- (void)selectIndex:(NSInteger)index{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:CustomSegmentedItem.class]) {
            CustomSegmentedItem *segItem = (CustomSegmentedItem*)subview;
            if (subview.tag == (index + kStartTag) ) {
                [segItem shouldHighlighted:YES];
            } else {
                [segItem shouldHighlighted:NO];
            }
        }
    }
}

- (void)setItemsWithArray:(NSArray*)items{
    for (UIView *subView in self.subviews) {
        if (![subView isEqual:_backgroundView]) {
            [subView removeFromSuperview];
        }
    }
    
    // Add items
    NSUInteger count = items.count;
    CGFloat width = (self.width - count - 1) / count;
    CGFloat height = self.height - 2;
    CGFloat startX = 1;
    NSUInteger tag = kStartTag;
    for (NSArray *itemDescription in items) {
        CustomSegmentedItem *item = [[CustomSegmentedItem alloc] initWithFrame:CGRectMake(startX, 1, width, height)];
        item.tag = tag;
        item.imageView.image = [UIImage imageNamed:itemDescription.firstObject];
        item.imageView.highlightedImage = [UIImage imageNamed:[(NSString*)(itemDescription.firstObject) stringByAppendingString:@"White"]];
        item.titleLabel.text = itemDescription[1];
        item.titleLabel.font = _font;
        item.titleLabel.textColor = _textColor;
        item.titleLabel.highlightedTextColor = _highlightTextColor;
        item.itemContainer = self;
        [item addTarget:self
                 action:@selector(touchUpInside:)
       forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:item];
        [item setNeedsLayout];
        startX += (width+1);
        tag++;
    }
    self.currentIndex = 0;
    [self selectIndex:self.currentIndex];
}
- (IBAction)touchUpInside:(CustomSegmentedItem*)sender{
    self.currentIndex = sender.tag - kStartTag;
    [self selectIndex:self.currentIndex];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)rotateImageWithAnimation:(BOOL)animated{
    [[self itemAtIndex:self.currentIndex] rotateImageWithAnimation:animated];
}

- (CGFloat)imageRadians{
    return [[self itemAtIndex:self.currentIndex] imageRadians];
}
@end
