//
//  ShareView.m
//  ScreenShareSample
//
//  Created by Xi Huang on 5/20/16.
//  Copyright © 2016 Lucas Huang. All rights reserved.
//

#import "ShareView.h"

@interface ShareModel()
@property (nonatomic) UIImage *sharedImage;
@property (nonatomic) NSDate *sharedDate;
@end

@implementation ShareModel

- (instancetype)initWithSharedImage:(UIImage *)sharedImage
                         sharedDate:(NSDate *)sharedDate {
    
    if (self = [super init]) {
        _sharedImage = sharedImage;
        _sharedDate = sharedDate;
    }
    return self;
}
@end


@interface ShareView()
@property (weak, nonatomic) IBOutlet UIView *contenView;
@property (weak, nonatomic) IBOutlet UIImageView *sharedImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageSizeLabel;
@end

@implementation ShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contenView.layer setCornerRadius:6.0f];
    [self.contenView.layer setShadowOpacity:0.6];
    [self.contenView.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [self.sharedImageView.layer setCornerRadius:6.0f];
    [self.sharedImageView.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.sharedImageView.layer setBorderWidth:1.0f];
}

- (void)updateWithShareModel:(ShareModel *)shareModel {
    
    if (!shareModel) return;
    
    self.sharedImageView.image = shareModel.sharedImage;
    
    NSData *sharedImageData = UIImageJPEGRepresentation(shareModel.sharedImage, 1.0);
    if (sharedImageData) {
        [self.imageSizeLabel setText:[NSString stringWithFormat:@"%ld KB", (unsigned long)[sharedImageData length] / 1024]];
    }
}

@end