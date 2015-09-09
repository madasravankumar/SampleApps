//
//  RegisterViewController.m
//  rnyoo_ios_client_v0.1
//
//  Created by iOS Dev 1 on 01/09/15.
//  Copyright (c) 2015 iOS Dev 1. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *screenField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;

- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextButtonPressed:(id)sender {
    
    if (self.emailfield.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter email Id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    }else if (![self validateEmail:self.emailfield.text]) {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid email id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    }else {
        
        NSURL* url = [NSURL URLWithString:@"http://android.rnyoo.ws/users/new"];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"RnyooAndroid" forHTTPHeaderField:@"x-rnyoo-client"];
        
//{"name_s":"Rajya Kavi", "userType_s":"general","gender_s":"female","screenName_s":"rajyakavi","password":"Salted_Password", "email_s":"rajyakavi@gmail.com","phone":{"countryCode":"+91","number":"9010991354"},"platformForReg":"android","oauthSource":"rnyoo","activated":false,"timeZone":"GMT +5:30","avatar":"http://rnyooassets.s3.amazonaws.com/avatars/default.png","statusMessage":"I Rnyoo","preferredChannels":["Gadgets"],"devices":{"android":[{"deviceId":"rajyakaviAndroidNoSocial","registrationId":"rajyakaviAndroidNoSocialRegId","deviceType":"phone","osVersion":"4.1.1","registeredOn":1414550816}]}}
        
        NSMutableDictionary* phoneDict = [NSMutableDictionary dictionary];
        [phoneDict setObject:@"+91" forKey:@"countryCode"];
        [phoneDict setObject:@"1234567890" forKey:@"number"];
        
        NSMutableDictionary* devicesDict = [NSMutableDictionary dictionary];
        NSMutableDictionary* deviceInfoDict = [NSMutableDictionary dictionary];
        [deviceInfoDict setObject:@"karthikiOSNoSocial" forKey:@"deviceId"];
        [deviceInfoDict setObject:@"karthikiOSNoSocialRegId" forKey:@"registrationId"];
        [deviceInfoDict setObject:@"phone" forKey:@"deviceType"];
        [deviceInfoDict setObject:@"8.0.1" forKey:@"osVersion"];
        [deviceInfoDict setObject:@"1414550816" forKey:@"registeredOn"];
        
        NSArray* deviceArrary = [NSArray arrayWithObject:deviceInfoDict];
        
        [devicesDict setObject:deviceArrary forKey:@"android"];
        
        NSMutableDictionary* primaryDict = [NSMutableDictionary dictionary];
        [primaryDict setObject:self.emailfield.text forKey:@"name_s"];
        [primaryDict setObject:@"general" forKey:@"userType_s"];
        [primaryDict setObject:@"male" forKey:@"gender_s"];
        [primaryDict setObject:self.screenField.text forKey:@"screenName_s"];
        [primaryDict setObject:self.pwdField.text forKey:@"password"];
        [primaryDict setObject:self.emailfield.text forKey:@"email_s"];
        [primaryDict setObject:phoneDict forKey:@"phone"];
        [primaryDict setObject:@"iOS" forKey:@"platformForReg"];
        [primaryDict setObject:@"rnyoo" forKey:@"oauthSource"];
        [primaryDict setObject:[NSNumber numberWithBool:0] forKey:@"activated"];
        [primaryDict setObject:@"GMT +5:30" forKey:@"timeZone"];
        [primaryDict setObject:@"http://rnyooassets.s3.amazonaws.com/avatars/default.png" forKey:@"avatar"];
        [primaryDict setObject:@"I Rnyoo" forKey:@"statusMessage"];
        [primaryDict setObject:@[@"Gadgets"] forKey:@"preferredChannels"];
        [primaryDict setObject:devicesDict forKey:@"devices"];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:primaryDict options:NSJSONWritingPrettyPrinted error:NULL];
        NSLog(@"JsonData: %@", [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]);
        
        [request setHTTPBody:jsonData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
           
            if (!connectionError) {
                id responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
                NSLog(@"Resoonse Data: %@", responseData);
                
            }else {
                if (connectionError) {
                    [[[UIAlertView alloc]initWithTitle:@"Alert" message:connectionError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                }
            }
        }];
    }
}
- (BOOL)validateEmail:(NSString *)inputText {
    
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:inputText]) {
        aRange = [inputText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [inputText length])];
        int indexOfDot = (int) aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [inputText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}

#pragma mark <UITextFieldDelegate> Methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
