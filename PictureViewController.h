//
//  PictureViewController.h
//  PictureMe
//
//  Created by Kenneth R. Lewis on 1/12/12.
//  Copyright (c) 2012 Killers Software. All rights reserved.
//

#import "UIViewControllerEx.h"

@class PictureViewController;

@protocol PictureViewControllerDelegate <NSObject>
@required
- (void)cancelledPictureView:(PictureViewController*)sender;
- (void)savedPictureView:(PictureViewController*)sender;
@end

@interface PictureViewController : UIViewControllerEx {
@private
    UIImageView* imageView;
    UIPageControl* pageCtrl;
    CGPoint lastGestureVelocity;
    id<PictureViewControllerDelegate>delegate;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageCtrl;
@property (nonatomic, assign) id<PictureViewControllerDelegate>delegate;

- (IBAction)pageCtrlValueChanged:(id)sender;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;
- (IBAction)move:(id)sender;
- (IBAction)bordersClicked:(id)sender;
- (IBAction)textClicked:(id)sender;

@end
