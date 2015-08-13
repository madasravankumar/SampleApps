//
//  ViewController.m
//  Canonpagepoc
//
//  Created by App Team on 13/08/15.
//  Copyright (c) 2015 App Team. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,weak) IBOutlet UIScrollView *scrollPage;
@property (nonatomic,strong)NSMutableArray *arr;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadCustomView];
    
     _arr=[[NSMutableArray alloc]initWithObjects:@"KillDil",@"PK",@"stadium", nil];
    [_scrollPage setContentSize:CGSizeMake([_arr count]*_scrollPage.frame.size.width, _scrollPage.frame.size.height)];
    NSLog(@"Scroll View Frame: %@", NSStringFromCGRect(self.scrollPage.frame));

    for (int i = 0; i < [_arr count]; i++) {
        
        UIImageView *tmpImage = [[UIImageView  alloc] initWithFrame:CGRectMake(i * _scrollPage.frame.size.width ,
                                                                      0,
                                                                      _scrollPage.frame.size.width,
                                                                      _scrollPage.frame.size.height)];
        
        NSLog(@"Image View Frame: %@", NSStringFromCGRect(tmpImage.frame));

        [tmpImage setImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:[_arr objectAtIndex:i ] ofType:@".jpg"]]];
        tmpImage.contentMode = UIViewContentModeScaleToFill;
        [_scrollPage addSubview:tmpImage];
    }
    self.automaticallyAdjustsScrollViewInsets = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadCustomView {
    
    self.view.frame = [[UIScreen mainScreen]bounds];
    [self.scrollPage setFrame:self.view.frame];
}
@end
