/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Chris Pan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>
#import "ConfirmationViewController.h"

@interface ConfirmationViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ConfirmationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.imageView.layer setBorderWidth: 2.0];
    
    self.imageView.image = self.imageToDisplay;
    self.textView.text = self.textToDisplay;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmButtonTouch:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Thanks" message:@"The pets are on their way!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Share", nil] show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        id pet = [FBGraphObject openGraphObjectForPostWithType:@"pextaxi:pet" title:self.navigationItem.title image:nil url:nil description:nil];
        id action = [FBGraphObject openGraphActionForPost];
        action[@"pet"] = pet;
        FBOpenGraphActionShareDialogParams *params = [FBOpenGraphActionShareDialogParams new];
        params.action = action;
        params.actionType = @"pextaxi:hire";
        params.previewPropertyName = @"pet";

        if ([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
            [FBDialogs presentShareDialogWithOpenGraphActionParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                if (error) {
                    NSLog(@"error:%@", error);
                }
            }];
        }        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
