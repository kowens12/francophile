//
//  ViewController.h
//  Franco
//
//  Created by Katherine Owens on 1/18/17.
//  Copyright © 2017 Katherine Owens. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UIToolbarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIImageView *francoImage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewCanvas;
@property (strong, nonatomic) IBOutlet UIView *canvas;
@property (strong, nonatomic) IBOutlet UIImageView *francoImageView; 

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)addPhoto:(UIBarButtonItem *)sender;
- (UIImage *)renderImage;
- (void)drawFrancoImageWithContextSize:(CGSize)contextSize francoImageView:(UIImageView *)francoImageView;

@end

