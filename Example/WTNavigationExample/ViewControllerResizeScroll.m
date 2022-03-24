//
//  UIViewController+ViewControllerResizeScroll.m
//  WTNavigationExample
//
//  Created by Mac on 27/4/2564 BE.
//  Copyright © 2564 BE wtanuw. All rights reserved.
//

#import "ViewControllerResizeScroll.h"

//
//  DemoTableViewController.swift
//  ImageInNavigationBarDemo
//
//  Created by Tung Fam on 11/14/17.
//  Copyright © 2017 Tung Fam. All rights reserved.
//

@interface ViewControllerResizeScroll()

    /// Image height/width for Large NavBar state
@property (nonatomic,assign) CGFloat ImageSizeForLargeState;
    /// Margin from right anchor of safe area to right anchor of Image
@property (nonatomic,assign) CGFloat ImageRightMargin;
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
@property (nonatomic,assign) CGFloat ImageBottomMarginForLargeState;
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
@property (nonatomic,assign) CGFloat ImageBottomMarginForSmallState;
    /// Image height/width for Small NavBar state
@property (nonatomic,assign) CGFloat ImageSizeForSmallState;
    /// Height of NavBar for Small state. Usually it's just 44
@property (nonatomic,assign) CGFloat NavBarHeightSmallState;
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
@property (nonatomic,assign) CGFloat NavBarHeightLargeState;
    /// Image height/width for Landscape state
@property (nonatomic,assign) CGFloat ScaleForImageSizeForLandscape;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) BOOL shouldResize;

@end

@implementation ViewControllerResizeScroll

+ (UINavigationController*)navigationControllerWithStoryboard
{
    id vct = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"resize"];
    UINavigationController *nvct = [[UINavigationController alloc] initWithRootViewController:vct];
    
    return nvct;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    /// WARNING: Change these constants according to your project's design
    /// Image height/width for Large NavBar state
    _ImageSizeForLargeState = 40;
    /// Margin from right anchor of safe area to right anchor of Image
    _ImageRightMargin = 16;
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    _ImageBottomMarginForLargeState = 12;
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    _ImageBottomMarginForSmallState = 6;
    /// Image height/width for Small NavBar state
    _ImageSizeForSmallState = 32;
    /// Height of NavBar for Small state. Usually it's just 44
    _NavBarHeightSmallState = 44;
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    _NavBarHeightLargeState = 96.5;
    /// Image height/width for Landscape state
    _ScaleForImageSizeForLandscape = 0.65;
    
    _imageView = [[UIImageView alloc] initWithImage:nil];
    _shouldResize = NO;
    
    
    [self setupUI];
    [self showTutorialAlert];
    [self observeAndHandleOrientationMode];

    if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation)) {
        _shouldResize = true;
    } else if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
        _shouldResize = false;
    }
}

-(void)setupUI
{
    //    // MARK: - Private methods
    //    private func setupUI() {
    //        navigationController?.navigationBar.prefersLargeTitles = true
    //
    //        title = "Resizing image 👉"
    //
    //        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
    //        guard let navigationBar = self.navigationController?.navigationBar else { return }
    //        navigationBar.addSubview(imageView)
    //        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
    //        imageView.clipsToBounds = true
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
    //                                             constant: -Const.ImageRightMargin),
    //            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
    //                                              constant: -Const.ImageBottomMarginForLargeState),
    //            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
    //            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
    //            ])
    //    }

}

-(void)showTutorialAlert
{
    //    private func showTutorialAlert() {
    //        let alert = UIAlertController(title: "Tutorial", message: "Scroll down and up to resize the image in navigation bar.", preferredStyle: .alert)
    //        let okAction = UIAlertAction(title: "Got it!", style: .default)
    //        alert.addAction(okAction)
    //        present(alert, animated: true)
    //    }
    //
    //}
    //

}

-(void)observeAndHandleOrientationMode
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
            self.title = @"Resizing image 👉";
            [self moveAndResizeImageForPortrait];
            self.shouldResize = true;
            } else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            self.title = @"Non 🙅🏽‍♂️ resizing image";
            [self resizeImageForLandscape];
            self.shouldResize = false;
        }
    }];
}

-(void)showImage:(BOOL)show
{
        /// Show or hide the image from NavBar while going to next screen or back to initial screen
        ///
        /// - Parameter show: show or hide the image from NavBar
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.alpha = show ? 1.0 : 0.0;
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showImage:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showImage:YES];
}

-(void)moveAndResizeImageForPortrait
{
    CGFloat height = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat delta = height - self.NavBarHeightSmallState;
    CGFloat heightDifferenceBetweenStates = (self.NavBarHeightLargeState - self.NavBarHeightSmallState);
    CGFloat coeff = delta / heightDifferenceBetweenStates;
    
    CGFloat factor = self.ImageSizeForSmallState / self.ImageSizeForLargeState;
    
    CGFloat sizeAddendumFactor = coeff * (1.0 - factor);
    CGFloat scale = MIN(1.0, sizeAddendumFactor + factor);
    
    // Value of difference between icons for large and small states
    CGFloat sizeDiff = self.ImageSizeForLargeState * (1.0 - factor); // 8.0
    
                /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
    CGFloat maxYTranslation = self.ImageBottomMarginForLargeState - self.ImageBottomMarginForSmallState + sizeDiff;
    CGFloat yTranslation =  MAX(0, MIN(maxYTranslation, (maxYTranslation - coeff * (self.ImageBottomMarginForSmallState + sizeDiff))))
    ;
    
    CGFloat xTranslation = MAX(0, sizeDiff - coeff * sizeDiff);
    _imageView.transform = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformIdentity, scale, scale), 0, yTranslation);
}

-(void)resizeImageForLandscape {
    CGFloat yTranslation = self.ImageSizeForLargeState * self.ScaleForImageSizeForLandscape;
    _imageView.transform = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformIdentity, self.ScaleForImageSizeForLandscape, self.ScaleForImageSizeForLandscape) ,0,yTranslation);
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_shouldResize) {
        [self moveAndResizeImageForPortrait];
    }
}

    // MARK: - Scroll View Delegates
-(void) scrollViewDidScroll:(UIScrollView*)scrollView {
  if (_shouldResize) {
      [self moveAndResizeImageForPortrait];
    }
}

@end

@implementation ViewControllerResizeScroll(tableView)

    // MARK: - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"re"];
    cell.textLabel.text = [NSString stringWithFormat:@"row %d",indexPath.row];
    return cell;
    }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//        performSegue(withIdentifier: "SegueID", sender: nil)
}

@end
