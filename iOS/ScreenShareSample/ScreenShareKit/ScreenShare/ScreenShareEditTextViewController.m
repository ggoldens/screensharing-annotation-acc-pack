//
//  ScreenShareEditTextViewController.m
//  ScreenShareSample
//
//  Created by Xi Huang on 6/2/16.
//  Copyright © 2016 Lucas Huang. All rights reserved.
//

#import "ScreenShareEditTextViewController.h"
#import "AnnotationTextView.h"

@interface ScreenShareEditTextViewController() <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic) AnnotationTextView *annotationTextView;

@property (nonatomic) NSArray<NSNumber *> * fontSizeArray;
@property (weak, nonatomic) IBOutlet UIButton *changeFontButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomLayoutConstraint;

@property (nonatomic) UIPickerView *changeFontPickerView;
@end

@implementation ScreenShareEditTextViewController

+ (instancetype)defaultWithTextColor:(UIColor *)textColor {
    
    return [[ScreenShareEditTextViewController alloc] initWithText:nil textColor:textColor fontSize:24.0f];
}

- (instancetype)initWithText:(NSString *)text
                   textColor:(UIColor *)textColor
                    fontSize:(CGFloat)fontSize {
    
    if (self = [super initWithNibName:@"ScreenShareEditTextViewController"
                               bundle:[NSBundle bundleForClass:[ScreenShareEditTextViewController class]]]) {
        
        _fontSizeArray = @[@24, @26, @28, @30, @32, @34, @36, @38, @40, @42, @44, @46, @48];
        
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
        CGRect mainBounds = [UIScreen mainScreen].bounds;
        blurView.frame = CGRectMake(0, 0, CGRectGetWidth(mainBounds), CGRectGetHeight(mainBounds));
        [self.view insertSubview:blurView atIndex:0];
        
        _annotationTextView  = [[AnnotationTextView alloc] initWithText:text textColor:textColor fontSize:fontSize];
        [_annotationTextView setUserInteractionEnabled:NO];
        [self.view addSubview:_annotationTextView];
        
        
        NSUInteger selectedRow = [self.fontSizeArray indexOfObject:@(fontSize)];
        if (selectedRow != NSNotFound) {
            
            _changeFontPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 300.0f)];
            [_changeFontPickerView setBackgroundColor:[UIColor whiteColor]];
            _changeFontPickerView.delegate = self;
            _changeFontPickerView.dataSource = self;
            [_changeFontPickerView selectRow:selectedRow inComponent:0 animated:NO];
        }
        
        [self styling];
    }
    return self;
}

- (void)styling {
    NSString *title = [NSString stringWithFormat:@"Tap to change font: %@pt", self.fontSizeArray[[self.changeFontPickerView selectedRowInComponent:0]]];
    [self.changeFontButton setTitle:title forState:UIControlStateNormal];
    [self.changeFontButton.layer setCornerRadius:5.0f];
    [self.doneButton.layer setCornerRadius:5.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.annotationTextView becomeFirstResponder];
    __weak ScreenShareEditTextViewController *weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(NSNotification *notification){
                                                      
                                                      CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                                                      CGFloat keyboardHeight = keyboardFrame.size.height;
                                                      dispatch_async(dispatch_get_main_queue(), ^(){
                                                          weakSelf.toolbarBottomLayoutConstraint.constant = keyboardHeight;
                                                          weakSelf.changeFontPickerView.frame = keyboardFrame;
                                                      });
                                                  }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.annotationTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)removeButtonPressed:(id)sender {
    if (self.delegate) {
        [self.delegate screenShareEditTextViewController:self didFinishEditing:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeFontButtonPressed:(UIButton *)sender {
    if (self.changeFontPickerView.superview) {
        NSString *title = [NSString stringWithFormat:@"Tap to change font: %@pt", self.fontSizeArray[[self.changeFontPickerView selectedRowInComponent:0]]];
        [sender setTitle:title forState:UIControlStateNormal];
        [self.changeFontPickerView removeFromSuperview];
    }
    else {
        [sender setTitle:@"Return to keyboard" forState:UIControlStateNormal];
        NSUInteger viewCount = [UIApplication sharedApplication].windows.count;
        UIWindow *topWindow = [UIApplication sharedApplication].windows[viewCount - 1];
        [topWindow addSubview:self.changeFontPickerView];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    if (self.delegate) {
        [self.delegate screenShareEditTextViewController:self didFinishEditing:self.annotationTextView];
    }
    [self.annotationTextView setUserInteractionEnabled:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.fontSizeArray.count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@pt", self.fontSizeArray[row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CGRectGetWidth(self.changeFontPickerView.bounds);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.annotationTextView setFont:[UIFont systemFontOfSize:[self.fontSizeArray[row] floatValue]]];
}
@end
