//
//  ViewController.m
//  GoogleCloudStorage
//
//  Created by Gemini-iMac2 on 15/07/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "GTLStorage.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MCPercentageDoughnutView.h"

@interface ViewController ()<GPPSignInDelegate,UIActionSheetDelegate,MCPercentageDoughnutViewDelegate,MCPercentageDoughnutViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) MCPercentageDoughnutView* percentageDoughnut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.layer.masksToBounds = YES;
    
    CGRect frame = CGRectMake(50 , self.imageView.center.y / 2 - 10, 100, 100);
    self.percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:frame];
    [self.imageView addSubview:self.percentageDoughnut];
    
    [self removeLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)googleButtonPressed:(UIButton *)sender {
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    signIn.clientID = @"49391190605-f5pas4sk9a2i8475p2clhjl28nbnqtjr.apps.googleusercontent.com";
    signIn.scopes = @[@"https://www.googleapis.com/auth/userinfo.email",kGTLAuthScopePlusLogin,kGTLAuthScopeStorageDevstorageReadWrite];
    signIn.delegate = self;
    [signIn authenticate];
    //[self uploadImageButtonPressed:self];
}
-(IBAction)uploadImageButtonPressed:(id)sender {
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Image From Gallery", nil];
    [actionSheet showInView:self.view];
}
-(void) uploadingImageWithAuthentication {
    
    UIImageView* bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.4];
    bgView.layer.cornerRadius = bgView.frame.size.width / 2;
    bgView.layer.masksToBounds = YES;
    [bgView setTag:1000];
    
    [self.imageView insertSubview:bgView belowSubview:self.percentageDoughnut];
    
    GTLServiceStorage* service = [GTLServiceStorage new];
    service.additionalHTTPHeaders = @{@"x-goog-project-id": @"493911906052", @"Content-Type": @"application/json-rpc"};
    service.retryEnabled = YES;
    //auth.authorizationTokenKey = [auth.parameters objectForKey:@"id_token"];
    service.authorizer = [[GPPSignIn sharedInstance]authentication];
    service.APIKey = @"AIzaSyCylB7M8udE26uRREWayEhmx9wJysEjUb0";
    
    GTLUploadParameters* uploadParameters = [GTLUploadParameters uploadParametersWithData:UIImageJPEGRepresentation(self.imageView.image, 1.0) MIMEType:@"image/jpeg"];
    
    GTLStorageObject *storageObj = [[GTLStorageObject alloc]init];
    storageObj.name = [[NSUUID UUID] UUIDString];
    storageObj.bucket = @"rank1bucket";
    //storageObj.acl = @[@"allUsers"];
    
    GTLQueryStorage *query = [GTLQueryStorage queryForObjectsInsertWithObject:storageObj bucket:@"rank1bucket" uploadParameters:uploadParameters];
    GTLServiceTicket *ticket = [service executeQuery:query delegate:self didFinishSelector:@selector(serviceTicket:finishedWithObject:error:)];
    
    ticket.uploadProgressBlock = ^(GTLServiceTicket *ticket,
                                   unsigned long long numberOfBytesRead,
                                   unsigned long long dataLength) {
        self.progressView.progress = (float)numberOfBytesRead/(float)dataLength;
        self.percentageDoughnut.linePercentage = 0.2;
        self.percentageDoughnut.fillColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        self.percentageDoughnut.percentage = self.progressView.progress;
        self.percentageDoughnut.animatesBegining = YES;
        self.percentageDoughnut.textLabel.hidden = YES;
    };
}
-(void) removeLoadingView {
    self.percentageDoughnut.dataSource = self;
    self.percentageDoughnut.linePercentage = 0.0;
    self.percentageDoughnut.percentage = 0.0;
    self.percentageDoughnut.animatesBegining = YES;
    self.percentageDoughnut.textLabel.hidden = YES;
}
-(void) serviceTicket:(GTLServiceTicket * )ticket finishedWithObject:(id) object error:(NSError *) error {
    [self.progressView setProgress:0.0];
    [self removeLoadingView];
    UIImageView* bgView = (UIImageView *) [self.view viewWithTag:1000];
    [bgView removeFromSuperview];
    
    NSLog(@"Error While Uploading Image: %@",error);
    NSLog(@"Object: %@", object);
}
#pragma mark <GPPSignInDelegate> Methods

-(void) finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    
    [self.googleButton setHidden:YES];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Upload Image" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 150, 50)];
    [button setCenter:self.view.center];
    [button setBackgroundColor:[UIColor darkGrayColor]];
    [button addTarget:self action:@selector(uploadImageButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:button];
    
    NSLog(@"Error While Login: %@",error);
    NSLog(@"Authentication: %@", auth);
}
-(void) didDisconnectWithError:(NSError *)error {
    NSLog(@"Error: %@",error);
}

#pragma mark <UIAction Sheet Delegate Methods>

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showImageFromGallery];
    }else {
        
    }
}
-(void) showImageFromGallery {
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    //imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
   // imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    [view setBackgroundColor:[UIColor clearColor]];
    view.center = self.view.center;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 250, 50)];
    [label setText:@"Hello This is the overlay view on camera"];
    
    [view addSubview:label];
    
    //imagePickerController.cameraOverlayView = view;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark <UIImagePickerControllerDelegate> Methods

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadingImageWithAuthentication];
    }];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <MCPercentageDoughnutViewDelegate> Methods

-(UIView *) viewForCenterOfPercentageDoughnutView:(MCPercentageDoughnutView *)pecentageDoughnutView withCenterView:(UIView *)centerView {
    return nil;
}

#pragma mark <MCPercentageDoughnutViewDataSource>

-(void) didSelectPercentageDoughnutView:(MCPercentageDoughnutView *)percentageDoughnut {
    
}
@end
