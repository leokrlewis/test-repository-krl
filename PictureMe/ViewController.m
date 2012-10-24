//
//  ViewController.m
//  PictureMe
//
//  Created by Kenneth R. Lewis on 1/11/12.
//  Copyright (c) 2012 Killers Software. All rights reserved.
//

#import "ViewController.h"
#import "PictureViewController.h"
#import "UINavigationControllerEx.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, PictureViewControllerDelegate>
@property (nonatomic, retain) UIImagePickerControllerEx* picker;
@property (nonatomic, retain) UIImage* originalPicture;
@property (nonatomic, retain) UIImage* editedPicture;
@property (nonatomic, retain) UIImage* savedPicture;
@end

@implementation ViewController

@synthesize picker, activity, imageView, loading, originalPicture, editedPicture, savedPicture, delegate;

#define TAG_PICK_PICTURE 0
#define TAG_TAKE_PICTURE 1

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

START_ANIMATING()

STOP_ANIMATING()

- (void)hideLoading {
    MAINTHREAD_SOMETHING(hideLoading)
    [self.loading setHidden:TRUE];
}

#pragma mark - View lifecycle

static BOOL _loadingPicker = FALSE;

- (void)loadPickerInBackground {
    if (nil == picker) {
        _loadingPicker = TRUE;
        picker = [UIImagePickerControllerEx new];
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
        picker.delegate = self;
        UIView* pickerView = picker.view;
        if (nil != pickerView) {
            NSLog(@"pickerView is there just to force load it.");
        }
        [self stopAnimating];
        [self hideLoading];
        _loadingPicker = FALSE;        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.picker = nil;
    self.imageView = nil;
    self.loading = nil;
    self.activity = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

static BOOL _onlyOnce = FALSE;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_onlyOnce) {
        [self startAnimating];
        QUEUE_SOMETHING(loadPickerInBackground)
        _onlyOnce = TRUE;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)cancelledPictureView:(PictureViewController *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)savedPictureView:(PictureViewController *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didSelectPicture {
    MAINTHREAD_SOMETHING(didSelectPicture)
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate didSelectPicture:self];
}

- (void)processImageInBackground:(NSDictionary*)dict {
    
    NSDictionary* info = [dict objectForKey:@"info"];
    NSNumber* tag = [dict objectForKey:@"tag"];
    
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
    NSData* imageData;
    
    if (nil != image) {
        imageData = UIImagePNGRepresentation(image);
        self.editedPicture = [UIImage imageWithData:imageData];
    } else {
        self.editedPicture = nil;
    }
    
    image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    if (nil != image) {
        imageData = UIImagePNGRepresentation(image);
        self.originalPicture = [UIImage imageWithData:imageData];
    } else {
        self.originalPicture = nil;
    }
    
    if (self.editedPicture) {
        self.savedPicture = self.editedPicture;
    } else {
        self.savedPicture = self.originalPicture;
    }
    int _tag = [tag intValue];
    if (_tag == TAG_TAKE_PICTURE) {
        UIImageWriteToSavedPhotosAlbum(self.savedPicture, nil, nil, nil);
    }
    
    [self didSelectPicture];
}

- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) != kCFCompareEqualTo) {
        [self messageBox:@"Invalid Type" withMsg:@"You cannot select this type of media type."];
        [self dismissModalViewControllerAnimated:YES];        
        return;
    }

    UIImagePickerControllerEx* pickerEx = (UIImagePickerControllerEx*)aPicker;
    NSNumber* tag = [NSNumber numberWithInt:pickerEx.tag];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:info, @"info", tag, @"tag", nil];
    QUEUE_SOMETHING_WITHOBJECT(processImageInBackground:, self, dict)
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES]; 
}

- (IBAction)pickPictureClicked:(id)sender {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)) {
        [self messageBox:@"No Camera" withMsg:@"Camera is not available."];
        return;
    }
    if (nil == self.picker || _loadingPicker) {
        [self messageBox:@"Not Available" withMsg:@"Camera Interface is currently not available at this time.  Try again in a second."];
        return;
    }
    picker.tag = TAG_PICK_PICTURE;
    picker.allowsEditing = NO;    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:self.picker animated:YES];

}

- (IBAction)takePictureClicked:(id)sender {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)) {
        [self messageBox:@"No Camera" withMsg:@"Camera is not available."];
        return;
    }
    if (nil == self.picker || _loadingPicker) {
        [self messageBox:@"Not Available" withMsg:@"Camera Interface is currently not available at this time.  Try again in a second."];
        return;
    }
    picker.tag = TAG_TAKE_PICTURE;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:self.picker animated:YES];    
}

- (void)dealloc {
    OBJC_DESTROY(picker)
    OBJC_DESTROY(activity)
    OBJC_DESTROY(imageView)
    OBJC_DESTROY(loading)
    OBJC_DESTROY(originalPicture)
    OBJC_DESTROY(editedPicture)
    OBJC_DESTROY(savedPicture)
    [super dealloc];
}
@end
