//
//  ViewController.m
//  Franco
//
//  Created by Katherine Owens on 1/18/17.
//  Copyright © 2017 Katherine Owens. All rights reserved.
//

#import "ViewController.h"
#import "FrancoCollectionViewController.h"
#import "Timer.h"

@interface ViewController () <UIToolbarDelegate, UIScrollViewDelegate, UIActivityItemSource, UIActionSheetDelegate,UIActivityItemSource, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageAspectRatioConstraint;
@property (strong, nonatomic) NSMutableArray<UIImageView *> *francos;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *unFrancoButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFranco:) name:@"francoNotification" object:nil];
    self.francos = [NSMutableArray array];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveFrancoAfterInactivity:) name:@"appInactiveNotification" object:nil];
}

- (void)setFranco:(NSNotification *)notification {
    NSDictionary *francoDictionary = notification.userInfo;
    UIImage *newFrancoImage = [UIImage imageNamed: [francoDictionary objectForKey:@"newFranco"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *newFrancoImageView = [[UIImageView alloc] initWithImage:newFrancoImage];
        newFrancoImageView.userInteractionEnabled = YES;
        [newFrancoImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
        [newFrancoImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)]];
        [self.canvas addSubview:newFrancoImageView];
        [self.francos addObject:newFrancoImageView];
        [self.unFrancoButton setEnabled:YES];
    });
}

-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGAffineTransform transform = recognizer.view.transform;
    recognizer.view.transform = CGAffineTransformTranslate(transform, translation.x, translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}


- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    CGFloat scale = [recognizer scale];
    CGAffineTransform transform = recognizer.view.transform;
    recognizer.view.transform = CGAffineTransformScale(transform, scale, scale);
    [recognizer setScale:1.0];
}

-(IBAction)addPhoto:(UIBarButtonItem *)sender {
    if ([self isCameraAndLibraryAvailable]) {
        [self createAlertWithCameraAndLibraryAction];
    } else if ([self isCameraAvailabile]) {
        [self createAlertWithCameraAction];
    } else if ([self isLibraryAvailable]) {
        [self createAlertWithLibraryAction];
    } else {
        [self createErrorAlert];
    }
}

- (BOOL)isCameraAvailabile {
    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    return YES;
}

- (BOOL)isLibraryAvailable {
    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    return YES;
}

- (BOOL)isCameraAndLibraryAvailable {
    [self isCameraAvailabile] && [self isLibraryAvailable];
    return YES;
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.userImage.image = chosenImage;
    self.userImageAspectRatioConstraint.constant = chosenImage.size.width / chosenImage.size.height;
    
    self.userImageAspectRatioConstraint.active = NO;
    self.userImageAspectRatioConstraint = [NSLayoutConstraint constraintWithItem:self.userImage
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.userImage
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:chosenImage.size.width / chosenImage.size.height
                                                                        constant:0];
    self.userImageAspectRatioConstraint.active = YES;
    
    [self.userImage setNeedsLayout];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)shareFranco:(id)sender {
    [self createFrancoActivityViewController];
}

- (void)createAlertWithCameraAndLibraryAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a Photo" message:@"Add a photo to Franco!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Add from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [alert addAction:cameraAction];
    [alert addAction:libraryAction];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)createAlertWithCameraAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a Photo" message:@"Add a photo to Franco!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [alert addAction:cameraAction];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)createAlertWithLibraryAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a Photo" message:@"Add a photo to Franco!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Add photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [alert addAction:libraryAction];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)createErrorAlert {
    UIAlertController *alert = [UIAlertController]
}

//- (void)saveFrancoAfterInactivity {
//    [self renderImage];
//    NSLog(@"saved");
//}

#pragma mark: Franco'd image

- (UIImage *)renderImage {
    CGRect contextRect = (self.userImage.image ? (CGRect){0, 0, self.userImage.image.size} : self.view.bounds);
    CGSize contextSize2 = contextRect.size;
    
    UIGraphicsBeginImageContextWithOptions(contextSize2, NO, 0.0);
    
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    
    [self.userImage.image drawInRect:contextRect];
    
    for (UIImageView *francoImageView in self.francos) {
        [self drawFrancoImageWithContextSize:contextSize2 francoImageView:francoImageView];
    }
    
    UIImage *francodImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return francodImage;
}

- (void)drawFrancoImageWithContextSize:(CGSize)contextSize francoImageView:(UIImageView *)francoImageView {
    CGRect francoImageFrameInView = [self.userImage convertRect:francoImageView.frame fromView:francoImageView.superview];

    CGSize userImageViewSize = self.userImage.frame.size;
    
    CGFloat scaleFactor = contextSize.height / userImageViewSize.height;
    CGRect scaledFrancoRect = CGRectMake(francoImageFrameInView.origin.x * scaleFactor,
                                         francoImageFrameInView.origin.y * scaleFactor,
                                         francoImageFrameInView.size.width * scaleFactor,
                                         francoImageFrameInView.size.height * scaleFactor);
    
    [francoImageView.image drawInRect:scaledFrancoRect];
}

- (IBAction)undoFranco:(id)sender {
    [[self.francos lastObject] removeFromSuperview];
    [self.francos removeLastObject];
    if (self.francos.count == 0) {
        [self.unFrancoButton setEnabled: NO];
    }
}


- (void) createFrancoActivityViewController{
    NSString *francoTextToShare = @"Consider this Franco'd!";
    UIImage *francoImageToShare = [self renderImage];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[francoTextToShare, francoImageToShare] applicationActivities:nil];
    
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypePostToVimeo, UIActivityTypeAddToReadingList, UIActivityTypeOpenInIBooks, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    
    [self.navigationController presentViewController:activityViewController animated:YES completion:^{
    }];
}

@end
