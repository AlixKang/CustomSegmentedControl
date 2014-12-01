//
//  CustomSegmentedControl.h
//  CustomSegmentedControl
//
//  Created by Alix on 12/1/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EImageLocation) {
    EImageAtLeft,
    EImageAtRight,
};

@interface CustomSegmentedControl : UIControl
@property (nonatomic, strong) UIFont  *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *hightlightBackgroundColor;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, assign) EImageLocation imageLocation;

@property (nonatomic, assign, readonly) BOOL isItemFirstSelected;

- (void)selectIndex:(NSInteger)index;

- (void)setItemsWithArray:(NSArray*)items;

- (void)rotateImageWithAnimation:(BOOL)animated;

- (CGFloat)imageRadians;
@end
