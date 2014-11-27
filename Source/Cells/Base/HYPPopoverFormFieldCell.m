#import "HYPPopoverFormFieldCell.h"

static const CGFloat HYPPopoverFormIconWidth = 38.0f;

@interface HYPPopoverFormFieldCell () <HYPTextFormFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic) CGSize contentSize;

@end

@implementation HYPPopoverFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)contentViewController
               andContentSize:(CGSize)contentSize
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _contentViewController = contentViewController;
    _contentSize = contentSize;

    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.iconImageView];

    return self;
}

#pragma mark - Getters

- (HYPTextFormField *)textField
{
    if (_textField) return _textField;

    _textField = [[HYPTextFormField alloc] initWithFrame:[self frameForTextField]];
    _textField.formFieldDelegate = self;

    return _textField;
}

- (UIPopoverController *)popoverController
{
    if (_popoverController) return _popoverController;

    _popoverController = [[UIPopoverController alloc] initWithContentViewController:self.contentViewController];
    _popoverController.delegate = self;
    _popoverController.popoverContentSize = self.contentSize;
    _popoverController.backgroundColor = [UIColor whiteColor];

    return _popoverController;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView) return _iconImageView;

    _iconImageView = [[UIImageView alloc] initWithFrame:[self frameForIconImageView]];
    _iconImageView.contentMode = UIViewContentModeRight;
    _iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _iconImageView;
}

#pragma mark - HYPTextFormFieldDelegate

- (void)textFormFieldDidBeginEditing:(HYPTextFormField *)textField
{
    [self updateContentViewController:self.contentViewController withField:self.field];

    if (!self.popoverController.isPopoverVisible) {
        [self.popoverController presentPopoverFromRect:self.bounds
                                                inView:self
                              permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                              animated:YES];
    }
}

#pragma mark - Private methods

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    abort();
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;
}

- (void)updateWithField:(HYPFormField *)field
{
    self.iconImageView.hidden = field.disabled;

    self.textField.hidden         = (field.sectionSeparator);
    self.textField.inputValidator = [self.field inputValidator];
    self.textField.formatter      = [self.field formatter];
    self.textField.typeString     = field.typeString;
    self.textField.enabled        = !field.disabled;
    self.textField.valid          = field.valid;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textField.frame = [self frameForTextField];

    self.iconImageView.frame = [self frameForIconImageView];
}

- (CGRect)frameForIconImageView
{
    CGRect frame = self.textField.frame;
    frame.origin.x = frame.size.width - HYPPopoverFormIconWidth;
    frame.size.width = HYPPopoverFormIconWidth;

    return frame;
}

- (CGRect)frameForTextField
{
    CGFloat marginX = HYPTextFormFieldCellMarginX;
    CGFloat marginTop = HYPTextFormFieldCellTextFieldMarginTop;
    CGFloat marginBotton = HYPTextFormFieldCellTextFieldMarginBottom;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

@end
