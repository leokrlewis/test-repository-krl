//
//  UIImagePickerControllerEx.h
//  PictureMe
//
//  Created by Kenneth R. Lewis on 1/12/12.
//  Copyright (c) 2012 Killers Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerControllerEx : UIImagePickerController {
@private
    int tag;
}

@property (nonatomic, assign) int tag;

@end
