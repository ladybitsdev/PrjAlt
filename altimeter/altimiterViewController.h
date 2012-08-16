//
//  altimiterViewController.h
//  altimeter
//
//  Created by Kristy Lee Gogolen on 12/26/11.
//  Copyright (c) 2012 LadyBits Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <Twitter/Twitter.h>

@class T1AverageValue;


#define kAltimiterSlideShowInterval 6
#define kAltimiterSlideShowTransitionDuration 4
#define kAltimiterSlideShowAdjustment -0.3

@interface altimiterViewController : UIViewController <CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate >

{
    CLLocationManager *locationManager;
    float altitudeNM;
    float altitude;
    NSString *altitudeString;
    UILabel *altitudeMetrics;
    UILabel *altitudeNotMetrics;
    UIButton *credit;
    NSArray *imageArray;
    UILabel *feet;
    UILabel *meters;
    NSString *measurementType;
    NSString *imageSource;
    UIButton *cameraButton;
    

    //options view
    UILabel *optionsViewFtLabel;
    UILabel *optionsViewMtrsLabel;
    UIButton *optionsViewMtrsButton;
    UIButton *optionsViewFtButton;
    
    //author view
    UILabel *titleAthletes;
    UILabel *titlePhoto;
    UILabel *titleDirection;
    UIButton *linkTG;
    UIButton *linkTK;
    UIButton *linkJC;
    UIButton *linkPS;
    UIButton *linkSupport;
    UIButton *linkFAQs;
    UIButton *emailDev;
    UIButton *linkSA;
    UIButton *linkJH;
    UIButton *linkMA;
    UIButton *moreAthletes;
    UIButton *morePhotographers;
  
    BOOL drawerOpen;
         
    NSTimer* timer;
         
    NSUInteger prevTopIndex; 
    NSUInteger topIndex;    
    float imageViewTopStoredAlpha; 
    NSTimeInterval animationStartTime;
    
    //photo feature
    UIImageView * imageView;
    UIImageView * imageView2;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
    UIView *photoFeatureView;
    UIView *photoFeatureOptionsView;
    BOOL newMedia;
    UIImage *chosenImage;
    UIImage *resultUIImage;
    UIView *photoView;
    UIButton *cancelButton; 
    UIButton *saveButton;
    UIButton *pvCamera;
    UIButton *pvLibrary;
    UIButton *pvTwitter;
    UIButton *pvFacebook;
    UIButton *pvEmailPhoto;
    UIButton *pvSavePhoto;
    UIImage *finalImage;
    UIButton *genericShareButton;
    UILabel *altitudePortraitPhotoView;
    UILabel *altitudeLandscapePhotoView;
    UILabel *altitudePhotoViewPortraitMeasurementTitle;
    UILabel *altitudePhotoViewLandscapeMeasurementTitle;
    NSString *imageOrientation;
    UIView *photoViewPhotoPortrait;
    UIView *photoViewPhotoLandscape;
    UIImage *image;


    //Button views
    UIView *buttonPhotoShareView;
    UIView *buttonAuthorView;
    UIView *buttonSettingsView;

    
}

-(IBAction)creditButtonPressed:(id)sender;
-(IBAction)optionsButtonPressed:(id)sender;
-(IBAction)authorButtonPressed:(id)sender;
-(IBAction)cameraButtonPressed:(id)sender;


-(IBAction)linkSA:(id)sender;
-(IBAction)linkJH:(id)sender;
-(IBAction)linkMA:(id)sender;
-(IBAction)linkMoreAthletes:(id)sender;
-(IBAction)linkMorePhotographers:(id)sender;

-(IBAction)linkTG:(id)sender;
-(IBAction)linkJC:(id)sender;
-(IBAction)linkPS:(id)sender;
-(IBAction)emailDev:(id)sender;
-(IBAction)linkSupport:(id)sender;
-(IBAction)linkLB:(id)sender;
-(IBAction)linkFAQs:(id)sender;

//settings
@property (strong, nonatomic) IBOutlet UIImageView *imageViewTop;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBottom;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *altitudeMetrics;
@property (strong, nonatomic) IBOutlet UILabel *altitudeNotMetrics;
@property (strong, nonatomic) IBOutlet UIButton *credit;
@property (strong, nonatomic) IBOutlet UIButton *optionsButton;
@property (strong, nonatomic) IBOutlet UIButton *authorInfoButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIImageView *comma;
@property (strong, nonatomic) IBOutlet T1AverageValue *altitudeAverage;
@property (strong, nonatomic) IBOutlet UIView *authorInfoView;
@property (strong, nonatomic) IBOutlet UIView *optionsView;
@property (strong, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic) IBOutlet UIView *superTopInterface;
@property (strong, nonatomic) IBOutlet UIView *topInterface;
@property (strong, nonatomic) IBOutlet UILabel *feet;
@property (strong, nonatomic) IBOutlet UILabel *meters;
@property BOOL drawerOpen;
@property (strong, nonatomic) NSTimer *timer;

//buttons
@property (strong, nonatomic) IBOutlet UIView *buttonPhotoShareView;
@property (strong, nonatomic) IBOutlet UIView *buttonAuthorView;
@property (strong, nonatomic) IBOutlet UIView *buttonSettingsView;



//author view
@property (strong, nonatomic) IBOutlet UILabel *titleAthletes;
@property (strong, nonatomic) IBOutlet UILabel *titlePhoto;
@property (strong, nonatomic) IBOutlet UILabel *titleDirection;
@property (strong, nonatomic) IBOutlet UIButton *linkTG;
@property (strong, nonatomic) IBOutlet UIButton *linkTK;
@property (strong, nonatomic) IBOutlet UIButton *linkJC;
@property (strong, nonatomic) IBOutlet UIButton *linkPS;
@property (strong, nonatomic) IBOutlet UIButton *emailDev;
@property (strong, nonatomic) IBOutlet UIButton *linkLB;
@property (strong, nonatomic) IBOutlet UIButton *linkSupport;
@property (strong, nonatomic) IBOutlet UIButton *linkFAQs;
@property (strong, nonatomic) IBOutlet UIButton *linkSA;
@property (strong, nonatomic) IBOutlet UIButton *linkMA;
@property (strong, nonatomic) IBOutlet UIButton *linkJH;
@property (strong, nonatomic) IBOutlet UIButton *moreAthletes;
@property (strong, nonatomic) IBOutlet UIButton *morePhotographers;


// options view
@property (strong, nonatomic) IBOutlet UILabel *optionsViewFtLabel;
@property (strong, nonatomic) IBOutlet UILabel *optionsViewMtrsLabel;
@property (retain, nonatomic) IBOutlet UIButton *optionsViewMtrsButton;
@property (retain, nonatomic) IBOutlet UIButton *optionsViewFtButton;


-(IBAction)optionsViewMtrsButton:(id)sender;
-(IBAction)optionsViewFtButton:(id)sender;

-(void)openDrawerOptions;
-(void)closeDrawerOptions;
-(void)openDrawerAuthor;
-(void)closeDrawerAuthor;
-(void)openDrawerCamera;
-(void)closeDrawerCamera;



// photo sharing feature
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView2;
@property (nonatomic, retain) IBOutlet UIButton *genericShareButton;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (strong, nonatomic) IBOutlet UIView *photoFeatureView;
@property (strong, nonatomic) IBOutlet UIView *photoFeatureOptionsView;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *pvCamera;
@property (strong, nonatomic) IBOutlet UIButton *pvLibrary;
@property (strong, nonatomic) IBOutlet UIButton *pvTwitter;
@property (strong, nonatomic) IBOutlet UIButton *pvFacebook;
@property (strong, nonatomic) IBOutlet UIButton *pvEmailPhoto;
@property (strong, nonatomic) IBOutlet UIButton *pvSavePhoto;
@property (strong, nonatomic) IBOutlet UIImage *resultUIImage; 
@property (strong, nonatomic) IBOutlet UIImage *finalImage;
@property (strong, nonatomic) IBOutlet UILabel *altitudePortraitPhotoView;
@property (strong, nonatomic) IBOutlet UILabel *altitudeLandscapePhotoView;

@property (strong, nonatomic) IBOutlet UILabel *altitudePhotoViewPortraitMeasurementTitle;
@property (strong, nonatomic) IBOutlet UILabel *altitudePhotoViewLandscapeMeasurementTitle;
@property (strong, nonatomic) IBOutlet UIImageView *commaPV;
@property (strong, nonatomic) IBOutlet UIView *photoViewPhotoLandscape;
@property (strong, nonatomic) IBOutlet UIView *photoViewPhotoPortrait;

@property (strong, nonatomic) IBOutlet UIImage *image;


-(IBAction)useCamera;
-(IBAction)useCameraRoll;
-(IBAction)cancelImageShare:(id)sender;
-(void)openPVOptions;
-(void)closePVOptions;

-(IBAction)tweetImage;
-(IBAction)emailImage;
-(IBAction)saveImage;

-(IBAction)shareButtonPressed:(id)sender;



@end
