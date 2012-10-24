//
//  ViewController.h
//  PictureMe
//
//  Created by Kenneth R. Lewis on 1/11/12.
//  Copyright (c) 2012 Killers Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerEx.h"
#import "UIImagePickerControllerEx.h"

@class ViewController;

@protocol ViewControllerDelegate <NSObject>
@required
- (void)didSelectPicture:(ViewController*)sender;
@end

@interface ViewController : UIViewControllerEx {
@private
    UIImagePickerControllerEx* picker;
    UIActivityIndicatorView* activity;
    UIImageView* imageView;
    UIImageView* loading;
    UIImage* editedPicture;
    UIImage* originalPicture;
    UIImage* savedPicture;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activity;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIImageView* loading;

@property (nonatomic, retain, readonly) UIImage* savedPicture;
@property (nonatomic, retain, readonly) UIImage* originalPicture;
@property (nonatomic, retain, readonly) UIImage* editedPicture;

@property (nonatomic, assign) id<ViewControllerDelegate>delegate;

- (IBAction)pickPictureClicked:(id)sender;
- (IBAction)takePictureClicked:(id)sender;

@end
