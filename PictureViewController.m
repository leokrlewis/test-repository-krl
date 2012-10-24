//
//  PictureViewController.m
//  PictureMe
//
//  Created by Kenneth R. Lewis on 1/12/12.
//  Copyright (c) 2012 Killers Software. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController () <UIGestureRecognizerDelegate>
@end

@implementation PictureViewController

@synthesize imageView, pageCtrl, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)move:(id)sender {
    NSLog(@"See a move gesture");
    UIPanGestureRecognizer* recognizer = (UIPanGestureRecognizer*)sender;
    CGPoint velocity = [recognizer velocityInView:self.imageView];
    if (velocity.x * lastGestureVelocity.x + velocity.y*lastGestureVelocity.y > 0) {
        NSLog(@"gesture went in the same direction");
    } else {
        NSLog(@"gesture went in the opposite direction");
    }
    lastGestureVelocity = velocity;    
}

- (IBAction)bordersClicked:(id)sender {
}

- (IBAction)textClicked:(id)sender {
}

- (IBAction)pinch:(id)sender {
    NSLog(@"See a pinch gesture");
}

- (IBAction)rotate:(id)sender {
    NSLog(@"See a rotate gesture");
}

- (IBAction)tap:(id)sender {
    NSLog(@"See a tap gesture");
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return TRUE;
}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*if (!TARGET_OS_IPAD()) {
        UIBarButtonItem* btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)];
        self.navigationItem.leftBarButtonItem = btnCancel;
        [btnCancel release];
        btnCancel = nil;
    }
    
    UIBarButtonItem* btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    [btnSave release];
    btnSave = nil;*/
    
    UIPinchGestureRecognizer* pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer* rotateRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
    [rotateRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:rotateRecognizer];
    
    UIPanGestureRecognizer* panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer* tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] autorelease];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:tapRecognizer];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.pageCtrl = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc {
    [imageView release];
    [pageCtrl release];
    [super dealloc];
}

- (IBAction)pageCtrlValueChanged:(id)sender {
    
}

- (IBAction)cancelClicked:(id)sender {
    [self.delegate cancelledPictureView:self];
}

- (IBAction)saveClicked:(id)sender {
    [self.delegate savedPictureView:self];
}

@end
