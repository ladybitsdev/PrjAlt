//
//  altimiterViewController.m
//  altimeter
//
//  Created by Kristy Lee Gogolen on 12/26/11.
//  Copyright (c) 2012 LadyBitsDev. All rights reserved.
//

#import "altimiterViewController.h"
#import "T1AverageValue.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation altimiterViewController
@synthesize imageViewTop;
@synthesize imageViewBottom;
@synthesize spinner;
@synthesize comma;
@synthesize optionsButton, authorInfoButton, credit;
@synthesize meters, feet;
@synthesize locationManager, altitudeMetrics, altitudeNotMetrics;
@synthesize altitudeAverage;
@synthesize authorInfoView, optionsView, cameraView, photoFeatureView, photoFeatureOptionsView;
@synthesize titleAthletes, titlePhoto, titleDirection, linkJC, linkPS, linkTG, linkTK, emailDev, linkSupport, linkFAQs;
@synthesize drawerOpen;
@synthesize optionsViewFtLabel, optionsViewMtrsLabel;
@synthesize optionsViewMtrsButton, optionsViewFtButton;
@synthesize linkLB;
@synthesize timer;
@synthesize cameraButton;
@synthesize imageView, takePhotoBtn, photoView;
@synthesize genericShareButton;
@synthesize saveButton;
@synthesize cancelButton;
@synthesize pvLibrary, pvCamera, pvEmailPhoto, pvSavePhoto, pvTwitter, pvFacebook;
@synthesize resultUIImage, finalImage;
@synthesize superTopInterface, topInterface;
@synthesize altitudePhotoView,altitudePhotoViewMeasurementTitle, commaPV;
@synthesize buttonAuthorView, buttonSettingsView, buttonPhotoShareView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#pragma mark CLLocationManagerDelegate



#pragma mark- photo feature

-(void)useCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = YES;       
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Camera Unavailable" message:@"You do not have a camera. Please choose another method." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    



    
}


-(void)useCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Photo Library Unavailable" message:@"Please choose another method." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    

    
    
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info {
    
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        [self dismissModalViewControllerAnimated:YES];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //resize image for memory purposes on iPhone 4
        CGSize newSize = CGSizeMake(720, 960);  

        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
        UIGraphicsEndImageContext(); 
        
        
        //Filter    
        CIImage *cimage = [[CIImage alloc] initWithImage:newImage];
        CIFilter *grayFilter = [CIFilter filterWithName:@"CIColorControls"];
        [grayFilter setDefaults];
        [grayFilter setValue:cimage forKey:@"inputImage"];
        
        [grayFilter setValue:[NSNumber numberWithDouble:0.0]
                      forKey:@"inputSaturation"];
        [grayFilter setValue:[NSNumber numberWithDouble:0.35]
                      forKey:@"inputBrightness"];
        [grayFilter setValue:[NSNumber numberWithDouble:1.8]
                      forKey:@"inputContrast"]; 
        
        CIImage *grayImage = [grayFilter outputImage];
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:grayImage fromRect:grayImage.extent];
        resultUIImage = [UIImage imageWithCGImage:cgImage];
        imageView.image = resultUIImage;
            
//        remove filter        
//        imageView.image = newImage;
        
    }   
    
    //show chosen photo
    [self setUpPhotoShareView];
    

}

-(void)setUpPhotoShareView {
    
    //show or hide various elements
    superTopInterface.alpha = 1.0;
    photoFeatureView.hidden = NO;

    altitudePhotoView.font = [UIFont fontWithName:@"Florencesans Exp" size:75];
    altitudePhotoViewMeasurementTitle.font = [UIFont fontWithName:@"Florencesans Exp" size:20];
    
    //choose between metric and imperial
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [defaults stringForKey:@"measurementType"];

    if([type isEqualToString: @"metric"]) {
        altitudeString =[NSString stringWithFormat:@"%g", floorf(altitude)];
        altitudeString = [NSString stringWithFormat:@"10000"];    // for testing
        altitudePhotoView.text = altitudeString;
        altitudePhotoViewMeasurementTitle.text = [NSString stringWithFormat:@"Meters"];
    } else {
        altitudeString = [NSString stringWithFormat:@"10000"];    // for testing
//        altitudeString =[NSString stringWithFormat:@"%g", floorf(altitudeNM)];
        altitudePhotoView.text = altitudeString;
        altitudePhotoViewMeasurementTitle.text = [NSString stringWithFormat:@"Feet"];              
    }
    
     
//label positioning    
    if (altitudePhotoView.text.length == 1) {
        [altitudePhotoView setFrame:CGRectMake(altitudePhotoView.frame.origin.x, 175, altitudePhotoView.frame.size.width, altitudePhotoView.frame.size.height)];
        commaPV.hidden = YES;
        
    }
    if (altitudePhotoView.text.length == 2) {
        [altitudePhotoView setFrame:CGRectMake(altitudePhotoView.frame.origin.x, 134, altitudePhotoView.frame.size.width, altitudePhotoView.frame.size.height)];
        commaPV.hidden = YES;
        
    }
    if (altitudePhotoView.text.length == 3) {
        [altitudePhotoView setFrame:CGRectMake(altitudePhotoView.frame.origin.x, 93, altitudePhotoView.frame.size.width, altitudePhotoView.frame.size.height)];
        commaPV.hidden = YES;
        
    }
    if (altitudePhotoView.text.length == 4) {
        [altitudePhotoView setFrame:CGRectMake(altitudePhotoView.frame.origin.x, 51, altitudePhotoView.frame.size.width, altitudePhotoView.frame.size.height)];
        commaPV.hidden = NO;
        
    }
    if (altitudePhotoView.text.length == 5) {
        [altitudePhotoView setFrame:CGRectMake(altitudePhotoView.frame.origin.x, 14, altitudePhotoView.frame.size.width, altitudePhotoView.frame.size.height)];
        commaPV.hidden = NO;
        
    }    
    

        
    [self openPVOptions];

}

-(void)removePhotoShareView {
    [self closeDrawerCamera];
    [self closePVOptions];
    photoFeatureView.hidden = YES;
    
}





-(void)image: (UIImage *)image finishedSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    if(error) {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Save Failed" message:@"Failed to save image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
    
    [self removePhotoShareView];
}




#pragma mark - share image methods

-(IBAction)shareButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"Choose your poison." 
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel" 
                                  destructiveButtonTitle:nil 
                                  otherButtonTitles:@"Tweet Photo", @"Email Photo", @"Save Photo", nil]; 
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;

    [actionSheet showInView:self.view]; 
}



- (void)actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex 
{ 
    if (buttonIndex == 1) 
    { 
        [self emailImage]; 
    } 
    
    if  (buttonIndex == [actionSheet cancelButtonIndex]) {
        //[self cancelImageShare];
        
    }
    
    if  (buttonIndex == 2) {
        [self saveImage];
    }    

    if  (buttonIndex == 0) {
        [self tweetImage];
    }   

} 


-(IBAction)cancelImageShare:(id)sender {    
    photoFeatureView.hidden = YES;
    [self removePhotoShareView];

    
}


-(IBAction)tweetImage{
   
    [self processImage];

    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    // Optional: set an image, url and initial text
    [twitter addImage:finalImage];
//    [twitter setInitialText:@"Tweet from iOS 5 app using the Twitter framework."];
    
    // Show the controller
    [self presentModalViewController:twitter animated:YES];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
//        NSString *title = @"Tweet Status";
//        NSString *msg; 
//        
//        if (result == TWTweetComposeViewControllerResultCancelled)
//            msg = @"Tweet compostion was canceled.";
//        else if (result == TWTweetComposeViewControllerResultDone)
//            msg = @"Tweet composition completed.";
        
        // Show alert to see how things went...
//        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        //[alertView show];
        
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
    };    
}

-(IBAction)emailImage{
    
    [self processImage];
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Check out my altitude."];
        

        
        NSData *imageData = UIImagePNGRepresentation(finalImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"myAltitude"]; 
        
        NSString *emailBody = @"Check out my altitude.";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
        
       

        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}





-(void)processImage {
    
    //hide buttons
    photoFeatureOptionsView.hidden = YES;
    

    //canvas of image

    CGSize destinationSize = CGSizeMake(320, 427);
    
    UIGraphicsBeginImageContextWithOptions(destinationSize, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();      

	[self.view.layer renderInContext:ctx];
	finalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    //don't save here, save manually
	//UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);
    
    
    //close and go to share choices
    photoFeatureOptionsView.hidden = NO;

    
}

-(IBAction)saveImage{

    [self processImage];
	UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);

    
    
    NSString *msg; 
    NSString *title = @"Image Saved!";
    
    msg = @"";
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alertView show];
    
    
}







#pragma mark - links


- (IBAction)linkPS:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.tenonedesign.com"]];    
}

- (IBAction)linkJC:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://primaloutdoorsmagazine.com/"]];    
}

- (IBAction)linkTG:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.tommygogolen.com"]];    
}

- (IBAction)linkTK:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.tommyking.com"]];    
}
- (IBAction)creditButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.ladybitsdev.com"]];    
}

-(IBAction)linkLB:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.ladybitsdev.com"]];    
}

- (IBAction)linkSupport:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.ladybitsdev.com/altimeter/support"]];    
}

- (IBAction)linkFAQs:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.ladybitsdev.com/altimeter/faqs"]];    
}

- (IBAction)emailDev:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"To LadyBit Development Team"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"kl@ladybitsdev.com", nil];
        [mailer setToRecipients:toRecipients];
        
                
        [self presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");

            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");

            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - open and close drawers 

-(void)openDrawerAuthor {
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [buttonAuthorView setFrame:CGRectMake(160, 118, 40, 52)];        
    [authorInfoView setFrame: CGRectMake(0,0,160,460)];
    
    //change alpha of background items
    topInterface.alpha = 0.1;
    credit.alpha = 0.1;
    superTopInterface.alpha = 0.1;
    buttonPhotoShareView.alpha = 0.1;
    buttonSettingsView.alpha = 0.1;
    
    
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
    self.drawerOpen = YES;
    
    
    //NSLog(@"Open Drawer");
    
    //disable opposing button
    cameraButton.enabled = NO;
    optionsButton.enabled = NO;
    
}

-(void)closeDrawerAuthor {
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [buttonAuthorView setFrame:CGRectMake(0, 118, 40, 52)];
    [authorInfoView setFrame: CGRectMake(-160,0,160,460)];
    
    //change alpha of background items
    topInterface.alpha = 1;
    superTopInterface.alpha = 1;
    buttonPhotoShareView.alpha = 1;
    buttonSettingsView.alpha = 1;
    
    
    [UIView setAnimationDuration:2.0];
    
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    
    [UIView commitAnimations];
    
    self.drawerOpen = NO;
    
    //NSLog(@"Close drawer"); 
    
    //renable opposing button
    cameraButton.enabled = YES;
    optionsButton.enabled = YES;
    
}

-(void)openDrawerOptions {
    
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [buttonSettingsView setFrame:CGRectMake(160, 62, 40, 50)];
    [optionsView setFrame: CGRectMake(0, 62, 160,52)];
    
    //change alpha of background items
    topInterface.alpha = 0.1;
    superTopInterface.alpha = 0.1; 
    buttonAuthorView.alpha = 0.1;
    buttonPhotoShareView.alpha = 0.1;
    
    
    
    [UIView setAnimationDuration:2.0];
    
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    
    [UIView commitAnimations];
    
    //NSLog(@"Opened");
    self.drawerOpen = YES;
    
    //disable opposing button
    authorInfoButton.enabled = NO;
    cameraButton.enabled = NO;

}


-(void)closeDrawerOptions {
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [buttonSettingsView setFrame:CGRectMake(0, 62, 40, 50)];
    [optionsView setFrame: CGRectMake(-160,62,160,52)];
    
    //change alpha of background items
    topInterface.alpha = 1;
    superTopInterface.alpha = 1;
    buttonAuthorView.alpha = 1;
    buttonPhotoShareView.alpha = 1;
    
    
    [UIView setAnimationDuration:2.0];
    
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    
    [UIView commitAnimations];
    
    //NSLog(@"Opened");
    self.drawerOpen = NO;
    
    //reenable opposing button
    authorInfoButton.enabled = YES;
    cameraButton.enabled = YES;
    
}


-(void)openDrawerCamera {
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [buttonPhotoShareView setFrame:CGRectMake(160, 6, 40, 52)];
    [cameraView setFrame: CGRectMake(0, 0, 160,101)];
    
    //change alpha of background items
    topInterface.alpha = 0.1;
    superTopInterface.alpha = 0.1;
    buttonAuthorView.alpha = 0.1;
    buttonSettingsView.alpha = 0.1;
    
    
    
    [UIView setAnimationDuration:2.0];
    
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    
    [UIView commitAnimations];
    
    //NSLog(@"Opened");
    self.drawerOpen = YES;
    
    //disable opposing button
    authorInfoButton.enabled = NO;
    optionsButton.enabled = NO;
}

-(void)closeDrawerCamera {
    
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [buttonPhotoShareView setFrame:CGRectMake(0, 6, 40, 52)];
    [cameraView setFrame: CGRectMake(-160,0,160,101)];
    
    //change alpha of background items
    topInterface.alpha = 1;
    superTopInterface.alpha = 1;
    buttonAuthorView.alpha = 1;
    buttonSettingsView.alpha = 1;
    
    
    [UIView setAnimationDuration:2.0];
    
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    
    [UIView commitAnimations];
    
    //NSLog(@"Opened");
    self.drawerOpen = NO;
    
    //reenable opposing button
    authorInfoButton.enabled = YES;
    optionsButton.enabled = YES;
}


//photo share feature drawer

-(void)openPVOptions {    
    
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [photoFeatureOptionsView setFrame: CGRectMake(0,427,320,33)];
  
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
}

-(void)closePVOptions {
    [UIView beginAnimations:@"" context:NULL];
    
    //The new position for view1 and button
    [photoFeatureOptionsView setFrame: CGRectMake(0,460,320,33)];
  
    
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];    
    
}


#pragma mark - main buttons


- (IBAction)authorButtonPressed:(id)sender {
    
    if(drawerOpen) {  //close drawer
        [self closeDrawerAuthor];        
    } else { // open drawer
        [self openDrawerAuthor];
    }
}

- (IBAction)optionsButtonPressed:(id)sender {
    
    if(drawerOpen) {  //close drawer
        [self closeDrawerOptions];
    } else { // open drawer
        [self openDrawerOptions];
    } 
}

- (IBAction)cameraButtonPressed:(id)sender {
    
    if(drawerOpen) {  //close drawer
        [self closeDrawerCamera];
    } else { // open drawer
        [self openDrawerCamera];
    } 
}



-(IBAction)optionsViewFtButton:(id)sender {
    //NSLog(@"feet button pressed");
    [optionsViewFtButton setSelected:YES];
    [optionsViewMtrsButton setSelected:NO];
    
    measurementType = @"imperial";
    feet.hidden = NO;
    meters.hidden = YES;
    altitudeMetrics.hidden = YES;
    altitudeNotMetrics.hidden = NO;
    //NSLog(@"switch to feet");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setObject:measurementType forKey:@"measurementType"];

    
}

-(IBAction)optionsViewMtrsButton:(id)sender {
    //NSLog(@"meters button pressed");
    [optionsViewFtButton setSelected:NO];
    [optionsViewMtrsButton setSelected:YES];
    
    measurementType = @"metric";
    
    feet.hidden = YES;
    meters.hidden = NO;
    altitudeNotMetrics.hidden = YES;
    altitudeMetrics.hidden = NO;
    //NSLog(@"switchMetric");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setObject:measurementType forKey:@"measurementType"];

}




#pragma mark - core location methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
         message:@"Altimiter was unable to read your altitude. Please check your wireless connection or cell service." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    altitudeString = [NSString stringWithFormat:@"-"]; 
    altitudeMetrics.text = altitudeString; 
        
    altitudeString = [NSString stringWithFormat:@"-"];
    altitudeNotMetrics.text = altitudeString;  
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    altitude = floorf(newLocation.altitude);
    altitude = [altitudeAverage averageValueWithValue:newLocation.altitude depth:20];
    
    
    
    // Discover metric number
    altitudeString =[NSString stringWithFormat:@"%g", floorf(newLocation.altitude)];
    altitudeMetrics.text = altitudeString;
 

    // Discover english unit number
    altitudeNM = floorf(newLocation.altitude * 3.2808399);
    altitudeString = [NSString stringWithFormat:@"%g", altitudeNM];
    altitudeNotMetrics.text = altitudeString;
    
    
    altitudeNotMetrics.text = [NSString stringWithFormat:@"%g", altitudeNM];

 

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [defaults stringForKey:@"measurementType"];
    
    
    
    if([type isEqualToString: @"metric"]) {
        feet.hidden = YES;
        meters.hidden = NO;
        altitudeNotMetrics.hidden = YES;
        altitudeMetrics.hidden = NO;
        
        [optionsViewFtButton setSelected:NO];
        [optionsViewMtrsButton setSelected:YES];
        
    } else {
        feet.hidden = NO;
        meters.hidden = YES;
        altitudeMetrics.hidden = YES;
        altitudeNotMetrics.hidden = NO;
        
        [optionsViewMtrsButton setSelected:NO];
        [optionsViewFtButton setSelected:YES];
 }
    
    //for testing purposes- feed in sample number
    //altitudeNotMetrics.text = [NSString stringWithFormat:@"12000"];    
   
    meters.font = [UIFont fontWithName:@"Florencesans Exp" size:15];
    feet.font = [UIFont fontWithName:@"Florencesans Exp" size:15];
    titlePhoto.font = [UIFont fontWithName:@"Florencesans Exp" size:15];
    titleAthletes.font = [UIFont fontWithName:@"Florencesans Exp" size:15];
    titleDirection.font = [UIFont fontWithName:@"Florencesans Exp" size:15];    
    linkTG.titleLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:12];
    linkTK.titleLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:12];
    linkPS.titleLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:12];
    linkSupport.titleLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:15];    
    linkJC.titleLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:12];
    emailDev.titleLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:12];
    linkFAQs.titleLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:12];    
    optionsViewFtLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:15];
    optionsViewMtrsLabel.font = [UIFont fontWithName:@"Florencesans Exp" size:15];
    altitudeMetrics.font = [UIFont fontWithName:@"Florencesans Exp" size:75];
    altitudeNotMetrics.font = [UIFont fontWithName:@"Florencesans Exp" size:75];

    
    // label positioning 1

    
    if (altitudeMetrics.text.length == 1) {
        [altitudeMetrics setFrame:CGRectMake(altitudeMetrics.frame.origin.x, 196, altitudeMetrics.frame.size.width, altitudeMetrics.frame.size.height)];
        comma.hidden = YES;

    }
    if (altitudeMetrics.text.length == 2) {
        [altitudeMetrics setFrame:CGRectMake(altitudeMetrics.frame.origin.x, 156, altitudeMetrics.frame.size.width, altitudeMetrics.frame.size.height)];
        comma.hidden = YES;

    }
    if (altitudeMetrics.text.length == 3) {
        [altitudeMetrics setFrame:CGRectMake(altitudeMetrics.frame.origin.x, 116, altitudeMetrics.frame.size.width, altitudeMetrics.frame.size.height)];
        comma.hidden = YES;

    }
    if (altitudeMetrics.text.length == 4) {
        [altitudeMetrics setFrame:CGRectMake(altitudeMetrics.frame.origin.x, 72, altitudeMetrics.frame.size.width, altitudeMetrics.frame.size.height)];
        comma.hidden = NO;

    }
    if (altitudeMetrics.text.length == 5) {
        [altitudeMetrics setFrame:CGRectMake(altitudeMetrics.frame.origin.x, 30, altitudeMetrics.frame.size.width, altitudeMetrics.frame.size.height)];
        comma.hidden = NO;

    }

// label positioning 2
    
    if (altitudeNotMetrics.text.length == 1) {
        [altitudeNotMetrics setFrame:CGRectMake(altitudeNotMetrics.frame.origin.x, 196, altitudeNotMetrics.frame.size.width, altitudeNotMetrics.frame.size.height)];
        comma.hidden = YES;
        
    }
    if (altitudeNotMetrics.text.length == 2) {
        [altitudeNotMetrics setFrame:CGRectMake(altitudeNotMetrics.frame.origin.x, 156, altitudeNotMetrics.frame.size.width, altitudeNotMetrics.frame.size.height)];
        comma.hidden = YES;
        
    }
    if (altitudeNotMetrics.text.length == 3) {
        [altitudeNotMetrics setFrame:CGRectMake(altitudeNotMetrics.frame.origin.x, 116, altitudeNotMetrics.frame.size.width, altitudeNotMetrics.frame.size.height)];
        comma.hidden = YES;
        
    }
    if (altitudeNotMetrics.text.length == 4) {
        [altitudeNotMetrics setFrame:CGRectMake(altitudeNotMetrics.frame.origin.x, 72, altitudeNotMetrics.frame.size.width, altitudeNotMetrics.frame.size.height)];
        comma.hidden = NO;
        
    }
    if (altitudeNotMetrics.text.length == 5) {
        [altitudeNotMetrics setFrame:CGRectMake(altitudeNotMetrics.frame.origin.x, 30, altitudeNotMetrics.frame.size.width, altitudeNotMetrics.frame.size.height)];
        comma.hidden = NO;
        
    }    
    
    
    [spinner stopAnimating];                      
}





- (void)viewDidLoad
{   

    self.drawerOpen = NO;

    altitudeAverage = [[T1AverageValue alloc] init];
    altitudeMetrics.hidden =YES;
    altitudeNotMetrics.hidden = YES;
    feet.hidden = YES;
    meters.hidden = YES; 
    
    // begin locating    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    self.credit = nil;
    [spinner startAnimating];
    // startLocation = nil;
    
// on load set values to nil
    altitudeString = [NSString stringWithFormat:@"-"]; 
    altitudeMetrics.text = altitudeString; 
    
    altitudeString = [NSString stringWithFormat:@"-"];
    altitudeNotMetrics.text = altitudeString; 
    
    prevTopIndex = 0; 
    topIndex = 1;
    
    
    imageArray = [NSArray arrayWithObjects:  
                  [UIImage imageNamed:@"image1.png"],   // tj smiling
//                  [UIImage imageNamed:@"josh.png"],  // wee skier
                  [UIImage imageNamed:@"image2b.png"],  // snowboarder
//                  [UIImage imageNamed:@"tomas-method.png"],  // wee skier
                  [UIImage imageNamed:@"sierra-jumping-rocks.png"],  // wee skier
                  [UIImage imageNamed:@"image3a.png"],  // wee skier
//                  [UIImage imageNamed:@"kate-hiking.png"],  // wee skier
                  [UIImage imageNamed:@"monarch.png"],  // wee skier
                  [UIImage imageNamed:@"hiking.png"],  // wee skier
//                  [UIImage imageNamed:@"kenny.png"],  // wee skier
                  [UIImage imageNamed:@"tj-halfpipe.png"],
                  [UIImage imageNamed:@"tj-trees.png"],
                  [UIImage imageNamed:@"sierra-mountains.png"],
                  [UIImage imageNamed:@"mountain-climbing.png"],
                  [UIImage imageNamed:@"brian-jackson.png"],  // wee skier
                  [UIImage imageNamed:@"tj-lunge-in-trees.png"],
                 nil];

    
// Just for fun, for later when object literals are supported by xcode
//    imageArray = @[[UIImage imageNamed:@"image1.png"],
//                   [UIImage imageNamed:@"image2b.png"],
//                   [UIImage imageNamed:@"image3a.png"],
//                   [UIImage imageNamed:@"image2b.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appOpens:) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appOpens:) name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appCloses:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
    

 //   [self imageAnimation];
    
    // initialize this here for first time use
    imageViewTopStoredAlpha = 1.0;
    imageViewTop.image = [imageArray objectAtIndex:prevTopIndex];

    //[self pretendToUnfreezeAnimation];
    [super viewDidLoad];
 
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1)
    {
        CGPoint p = [aTouch locationInView:self.view];
        if (!CGRectContainsPoint(optionsView.frame, p))
        {
            
            if(drawerOpen) { 
                [self closeDrawerOptions];
                [self closeDrawerAuthor];
                [self closeDrawerCamera];

            } else {
                
            }
        }
    }
}


#pragma mark animation code

-(void)appCloses:(NSNotification *)notification {
    //NSLog(@"app closes");
    [self pretendToFreezeAnimation];
}



-(void)appOpens:(NSNotification *)notification {
    //NSLog(@"app opens"); 
    [self pretendToUnfreezeAnimation];
}

- (void)pretendToUnfreezeAnimation {
    imageViewTop.alpha = imageViewTopStoredAlpha;
    [UIView animateWithDuration:kAltimiterSlideShowTransitionDuration
                          delay:0 
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear 
                     animations:^{
                         
                         imageViewTop.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         //NSLog(@"unfreeze animation completed with value %d",finished);
                         if (finished) {
                             [self startBackgroundAnimation];

                         }
                         else {
                             imageViewTop.alpha = 1.0;
                         }
                     }];
}
- (void)pretendToFreezeAnimation {
    [timer invalidate];
    animationStartTime = animationStartTime + kAltimiterSlideShowAdjustment;
    
    NSTimeInterval now = [[NSProcessInfo processInfo] systemUptime];
    if ((now - animationStartTime) < kAltimiterSlideShowTransitionDuration) {
        imageViewTopStoredAlpha = (now - animationStartTime)/kAltimiterSlideShowTransitionDuration;
    }
    else {
        imageViewTopStoredAlpha = 1;
    }

}

-(void)startBackgroundAnimation {
    
    self.timer = [NSTimer timerWithTimeInterval:kAltimiterSlideShowInterval
                                             target:self 
                                           selector:@selector(onTimer) 
                                           userInfo:nil 
                                            repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

        imageViewBottom.image = [imageArray objectAtIndex:prevTopIndex];
        imageViewTop.image = [imageArray objectAtIndex:topIndex];
        imageViewTop.alpha = 0;

}



-(void)onTimer{
    // rotate previous image to bottom
    imageViewBottom.image = [imageArray objectAtIndex:prevTopIndex];
    
    // bring new image in on top, but hide it so nobody knows
    imageViewTop.image = [imageArray objectAtIndex:topIndex];
    imageViewTop.alpha = 0;
    
    [UIView animateWithDuration:kAltimiterSlideShowTransitionDuration
                          delay:0 
                          options: UIViewAnimationOptionAllowUserInteraction 
                          animations:^{
                         
                              imageViewTop.alpha = 1.0;
                          }
                     completion:nil];
    animationStartTime = [[NSProcessInfo processInfo] systemUptime];
    
    prevTopIndex = topIndex; 
    topIndex++; 
    if(topIndex >= [imageArray count]){
        topIndex = 0; 
    }
}







- (void)viewDidUnload
{
    
    [self setSpinner:nil];
    [self setImageViewBottom:nil];
    [self setImageViewTop:nil];
    [self setImageViewBottom:nil];
    [super viewDidUnload];
    self.locationManager = nil;
    self.altitudeMetrics = nil;
    self.altitudeNotMetrics = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationWillEnterForegroundNotification" object:nil];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationDidFinishLaunchingNotification" object:nil];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationDidEnterBackgroundNotification" object:nil];    
   
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
        //return NO; 
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||

    interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown );


}

@end
