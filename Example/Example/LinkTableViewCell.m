// LinkTableViewCell.m
//
// Copyright (c) 2013 Sam Symons (http://samsymons.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#define EDGE_PADDING 10.0

#define METADATA_FONT_SIZE 13.0
#define METADATA_TEXT_COLOR [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.0]
#define METADATA_IMAGE_COLOR [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0]

#import "LinkTableViewCell.h"
#import "LinkTitleLabel.h"

@interface LinkTableViewCell ()

@property (nonatomic, strong) UIImageView *votesImageView;
@property (nonatomic, strong) UIImageView *commentsImageView;

- (void)setMetadataState:(BOOL)highlightedOrSelected;

- (NSDictionary *)autoLayoutViews;

- (void)applyConstraints;
- (void)applyVerticalConstraints;
- (void)applyTitleConstraints;
- (void)applyMetadataConstraints;

- (UILabel *)metadataLabelWithDefaultStyle;
- (UIImageView *)imageViewWithImageName:(NSString *)imageName;

@end

@implementation LinkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.contentMode = UIViewContentModeRedraw;
        
        _titleLabel = [[LinkTitleLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor whiteColor];
		
        _votesImageView = [self imageViewWithImageName:@"Votes"];
        _commentsImageView = [self imageViewWithImageName:@"Comments"];
		
        _commentsLabel = [self metadataLabelWithDefaultStyle];
        _karmaLabel = [self metadataLabelWithDefaultStyle];
        _subredditLabel = [self metadataLabelWithDefaultStyle];
        _authorLabel = [self metadataLabelWithDefaultStyle];
		
        [[self contentView] addSubview:_titleLabel];
        [[self contentView] addSubview:_votesImageView];
        [[self contentView] addSubview:_karmaLabel];
        [[self contentView] addSubview:_commentsImageView];
        [[self contentView] addSubview:_commentsLabel];
        [[self contentView] addSubview:_subredditLabel];
        
        [self applyConstraints];
    }
	
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [self setMetadataState:highlighted];
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self setMetadataState:selected];
    [super setSelected:selected animated:animated];
}

#pragma mark - Private

- (void)setMetadataState:(BOOL)highlightedOrSelected
{
    UIColor *imageColor = highlightedOrSelected ? [UIColor lightGrayColor] : METADATA_IMAGE_COLOR;
    UIColor *textColor = highlightedOrSelected ? [UIColor grayColor] : METADATA_TEXT_COLOR;
    
    self.votesImageView.tintColor = imageColor;
    self.commentsImageView.tintColor = imageColor;
    self.karmaLabel.textColor = textColor;
    self.commentsLabel.textColor = textColor;
    self.subredditLabel.textColor = textColor;
}

- (NSDictionary *)autoLayoutViews
{
    return @{
        @"title": self.titleLabel,
        @"subreddit": self.subredditLabel,
        @"votesImage": self.votesImageView,
        @"karma": self.karmaLabel,
        @"commentsImage": self.commentsImageView,
        @"comments": self.commentsLabel
    };
}

- (void)applyConstraints
{
    [[self contentView] removeConstraints:self.contentView.constraints];
	
    [self applyVerticalConstraints];
    [self applyTitleConstraints];
    [self applyMetadataConstraints];
    
    NSLayoutConstraint *paddingConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                            toItem:self.karmaLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:EDGE_PADDING];
    paddingConstraint.priority = UILayoutPriorityRequired;
    
    [[self contentView] addConstraint:paddingConstraint];
}

- (void)applyVerticalConstraints
{   
    NSLayoutConstraint *titleConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.contentView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:EDGE_PADDING];
    titleConstraint.priority = UILayoutPriorityRequired;
    [[self contentView] addConstraint:titleConstraint];
    
    NSArray *spacingConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(5)-[karma]" options:0 metrics:0 views:[self autoLayoutViews]];
    [[self contentView] addConstraints:spacingConstraints];
}

- (void)applyTitleConstraints
{
    NSDictionary *views = [self autoLayoutViews];
    
    NSString *titleFormat = @"H:|-(14)-[title]-(14)-|";
    NSArray *titleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:titleFormat options:0 metrics:nil views:views];
    
    [[self contentView] addConstraints:titleConstraints];
}

- (void)applyMetadataConstraints
{
    NSDictionary *views = [self autoLayoutViews];
    
    NSLayoutConstraint *votesImageConstraint = [NSLayoutConstraint constraintWithItem:self.votesImageView
                                                                            attribute:NSLayoutAttributeLeading
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.titleLabel
                                                                            attribute:NSLayoutAttributeLeading
                                                                           multiplier:1.0
                                                                             constant:1];
    votesImageConstraint.priority = UILayoutPriorityRequired;
    [[self contentView] addConstraint:votesImageConstraint];
    
    NSString *metadataFormat = @"H:[votesImage]-(4)-[karma]-(12)-[commentsImage]-(4)-[comments]-(>=10)-[subreddit]-|";
    NSArray *metadataConstraints = [NSLayoutConstraint constraintsWithVisualFormat:metadataFormat options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    
    [[self contentView] addConstraints:metadataConstraints];
}

- (UILabel *)metadataLabelWithDefaultStyle
{
    UILabel *metadataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    metadataLabel.translatesAutoresizingMaskIntoConstraints = NO;
    metadataLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:METADATA_FONT_SIZE];
    metadataLabel.textColor = METADATA_TEXT_COLOR;
    metadataLabel.backgroundColor = [UIColor whiteColor];
    
    return metadataLabel;
}

- (UIImageView *)imageViewWithImageName:(NSString *)imageName
{
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tintColor = METADATA_IMAGE_COLOR;
    
    return imageView;
}

@end
