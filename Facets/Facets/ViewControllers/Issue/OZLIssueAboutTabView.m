//
//  OZLIssueAboutTabView.m
//  Facets
//
//  Created by Justin Hill on 11/7/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import "OZLIssueAboutTabView.h"

@interface OZLIssueAboutTabView ()

@property NSMutableArray *labels;
@property CGFloat minColumnWidth;
@property NSInteger currentLayoutItemsPerColumn;

@end

@implementation OZLIssueAboutTabView

@synthesize heightChangeListener;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    NSLog(@"%@", NSStringFromCGRect(frame));
}

- (void)setup {
    self.labels = [NSMutableArray array];
    self.fieldNameFont = [UIFont OZLMediumSystemFontOfSize:12.];
    self.fieldValueFont = [UIFont systemFontOfSize:12];
    self.minColumnWidth = 150.;
}

- (void)applyIssueModel:(OZLModelIssue *)issueModel {
    [self.labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *labels = [NSMutableArray array];
    
    if (issueModel.status) {
        [labels addObject:[self labelForFieldName:@"Status" value:issueModel.status.name]];
    }
    
    if (issueModel.priority) {
        [labels addObject:[self labelForFieldName:@"Priority" value:issueModel.priority.name]];
    }
    
    if (issueModel.category) {
        [labels addObject:[self labelForFieldName:@"Category" value:issueModel.category.name]];
    }
    
    if (issueModel.targetVersion) {
        [labels addObject:[self labelForFieldName:@"Target version" value:issueModel.targetVersion.name]];
    }
    
    if (issueModel.author) {
        [labels addObject:[self labelForFieldName:@"Author" value:issueModel.author.name]];
    }
    
    self.labels = labels;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    CGFloat usableWidth = self.frame.size.width - (self.contentPadding * 2);
    CGFloat colCount = floorf(usableWidth / self.minColumnWidth);
    CGFloat colWidth = usableWidth / colCount;
    NSInteger itemsPerColumn = ceilf(self.labels.count / colCount);
    
//    NSLog(@"usableWidth: %f, colCount: %f, colWidth: %f, itemsPerCol: %ld, labels: %ld", usableWidth, colCount, colWidth, itemsPerColumn, self.labels.count);
    
    self.currentLayoutItemsPerColumn = itemsPerColumn;
    
    UILabel *previousLabel;
    
    for (NSInteger i = 0; i < self.labels.count; i++) {
        NSInteger colIndex = i / itemsPerColumn;
        NSInteger rowIndex = i % itemsPerColumn;
        UILabel *label = self.labels[i];
        
        if (!label.superview) {
            [self addSubview:label];
        }
        
        CGFloat xOffset = self.contentPadding + (colIndex * colWidth);
        CGFloat yOffset;
        
        if (rowIndex == 0) {
            yOffset = self.contentPadding;
        } else {
            yOffset = previousLabel.bottom + (self.contentPadding / 3);
        }
        
//        NSLog(@"index: %ld, x: %f, y: %f", i, xOffset, yOffset);
        label.frame = (CGRect){{xOffset, yOffset}, label.frame.size};
        previousLabel = label;
    }
}

- (UILabel *)labelForFieldName:(NSString *)name value:(NSString *)value {
    NSString *joined = [NSString stringWithFormat:@"%@: %@", name, value];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:joined];
    [aString addAttribute:NSFontAttributeName value:self.fieldNameFont range:NSMakeRange(0, name.length + 1)];
    [aString addAttribute:NSFontAttributeName value:self.fieldValueFont range:NSMakeRange(name.length + 2, value.length)];
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = aString;
    label.numberOfLines = 1;
    label.textColor = [UIColor darkGrayColor];
    [label sizeToFit];
    
    return label;
}

- (CGFloat)intrinsicHeightWithWidth:(CGFloat)width {
    if (!self.labels.count) {
        return 0;
    }
    
    self.bounds = CGRectMake(0, 0, width, 0);
    [self layoutSubviews];
    
    UILabel *bottomRowLabel = self.labels[self.currentLayoutItemsPerColumn - 1];
    
    return bottomRowLabel.bottom + self.contentPadding;
}

@end
