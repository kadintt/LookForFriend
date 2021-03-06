/*
 The MIT License (MIT)

 Copyright (c) 2014 Suyeol Jeon (http://xoul.kr)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

#import "UITextView+Category.h"
#import <objc/runtime.h>

@interface DeallocHooker : NSObject

@property (nonatomic, strong) void (^willDealloc)(void);

@end

@implementation DeallocHooker

- (void)dealloc {
    if (self.willDealloc) {
        self.willDealloc();
    }
}

@end


@implementation UITextView (Placeholder)

#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColor`

+ (UIColor *)defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:225/255.0 green:224/255.0 blue:223/255.0 alpha:1.0];
    });
    return color;
}


#pragma mark - Properties
#pragma mark `placeholderLabel`

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!label) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;

        label = [[UILabel alloc] init];
        label.textColor = [self.class defaultPlaceholderColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        NSArray *observingKeys = @[@"attributedText",
                                   @"bounds",
                                   @"font",
                                   @"frame",
                                   @"text",
                                   @"textAlignment",
                                   @"textContainerInset"];
        for (NSString *key in observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }

        DeallocHooker *hooker = [[DeallocHooker alloc] init];
        hooker.willDealloc = ^{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            for (NSString *key in observingKeys) {
                [self removeObserver:self forKeyPath:key];
            }
        };
        objc_setAssociatedObject(self, @"deallocHooker", hooker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}


#pragma mark `placeholder`

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabel];
}


#pragma mark `placeholderColor`

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self updatePlaceholderLabel];
}


#pragma mark - Update

- (void)updatePlaceholderLabel {
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }

    [self insertSubview:self.placeholderLabel atIndex:0];

    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textAlignment = self.textAlignment;

    CGFloat x = self.textContainer.lineFragmentPadding + self.textContainerInset.left;
    CGFloat y = self.textContainerInset.top;
    CGFloat width = (CGRectGetWidth(self.bounds) - x - self.textContainer.lineFragmentPadding
                     - self.textContainerInset.right);
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

@end
