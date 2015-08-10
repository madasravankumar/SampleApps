//
//  ViewController.m
//  TableViewReorderCell
//
//  Created by Gemini-iMac2 on 02/06/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger autoscrollDistance;
@property (nonatomic, strong) NSTimer *autoscrollTimer;
@property (nonatomic, strong) UIView *snapshotOfMovingCell;
@property (nonatomic, strong) UILongPressGestureRecognizer* movingGestureRecognizer;
@property (nonatomic, assign) NSInteger autoscrollThreshold;
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, strong) NSIndexPath* movingIndexPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(editButton:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    //Adding Long Press Gesture Recognizer
    self.movingGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecong:)];
    [self.tableView addGestureRecognizer:self.movingGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UIButton> Methods

-(void) longPressGestureRecong:(UILongPressGestureRecognizer *) gesRec {
    
    UIGestureRecognizerState state = gesRec.state;
    
    CGPoint location = [gesRec locationInView:self.tableView];
    self.movingIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static NSIndexPath* sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:

            if (self.movingIndexPath) {

                sourceIndexPath = self.movingIndexPath;
                
                TableViewCell* cell = (TableViewCell *)[self.tableView cellForRowAtIndexPath:sourceIndexPath];
                
                self.snapshotOfMovingCell = [self customSnapshotFromView:cell];
                
                __block CGPoint center = cell.center;
                self.snapshotOfMovingCell.center = center;
                self.snapshotOfMovingCell.alpha = 0.0;
                [self.tableView addSubview:self.snapshotOfMovingCell];
                
                self.autoscrollThreshold = CGRectGetHeight(self.snapshotOfMovingCell.frame) * 0.6;
                self.autoscrollDistance = 0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    NSLog(@"Location At Begin: %@", NSStringFromCGPoint(location));
                    center.y = location.y;
                    self.snapshotOfMovingCell.center = center;
                    self.snapshotOfMovingCell.transform = CGAffineTransformMakeScale(0.7, 0.7);
                    self.snapshotOfMovingCell.alpha = 1.0;
                    
                    cell.alpha = 0.0;
                }completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        case UIGestureRecognizerStateChanged: {
            NSLog(@"Location After: %@", NSStringFromCGPoint(location));

            CGPoint center = self.snapshotOfMovingCell.center;
            center.y = location.y;
            self.snapshotOfMovingCell.center = center;
            [self maybeAutoscroll];
            if (![self isAutoscrolling]) {
                if (self.movingIndexPath && ![self.movingIndexPath isEqual:sourceIndexPath]) {
                    
                    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:self.movingIndexPath];
                    sourceIndexPath = self.movingIndexPath;
                }
            }
            
            break;
        }
        default:{
            // Clean up.
            TableViewCell *cell = (TableViewCell *) [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                
                self.snapshotOfMovingCell.center = cell.center;
                self.snapshotOfMovingCell.transform = CGAffineTransformIdentity;
                self.snapshotOfMovingCell.alpha = 0.0;
                
                // Undo fade out.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [self.snapshotOfMovingCell removeFromSuperview];
                self.snapshotOfMovingCell = nil;
                
            }];

        }
            break;
    }
}
// Add this at the end of your .m file. It returns a customized snapshot of a given view.
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
- (void)editButton:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:YES];
        [self.tableView setEditing:NO animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

#pragma mark <UITableViewDataSource> Methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell* cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark <Auto Scrolling>
- (BOOL)canScroll
{
    return (CGRectGetHeight(self.tableView.frame) < self.tableView.contentSize.height);
}
- (BOOL)isAutoscrolling
{
    return (self.autoscrollDistance != 0);
}
- (void)stopAutoscrolling
{
    self.autoscrollDistance = 0.0;
    [self.autoscrollTimer invalidate];
    self.autoscrollTimer = nil;
}
- (void)legalizeAutoscrollDistance
{
    CGFloat minimumLegalDistance = self.tableView.contentOffset.y * -1.0;
    CGFloat maximumLegalDistance = self.tableView.contentSize.height - (CGRectGetHeight(self.tableView.frame) + self.tableView.contentOffset.y);
    self.autoscrollDistance = MAX(self.autoscrollDistance, minimumLegalDistance);
    self.autoscrollDistance = MIN(self.autoscrollDistance, maximumLegalDistance);
}
- (void)autoscrollTimerFired:(NSTimer *)timer
{
    [self legalizeAutoscrollDistance];
    
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y += self.autoscrollDistance;
    self.tableView.contentOffset = contentOffset;
    
    CGRect frame = self.snapshotOfMovingCell.frame;
    frame.origin.y += self.autoscrollDistance;
    self.snapshotOfMovingCell.frame = frame;
    
    CGPoint touchLocation = [self.movingGestureRecognizer locationInView:self.tableView];
   // [self moveRowToLocation:touchLocation];
    NSIndexPath* sourceIndexPath = [self.tableView indexPathForRowAtPoint:touchLocation];
    
    CGPoint center = self.snapshotOfMovingCell.center;
    center.y = touchLocation.y;
    self.snapshotOfMovingCell.center = center;
    
    /*if (self.movingIndexPath && ![self.movingIndexPath isEqual:sourceIndexPath]) {
        
        [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:self.movingIndexPath];
        sourceIndexPath = self.movingIndexPath;
    }*/
}
- (CGFloat)autoscrollDistanceForProximityToEdge:(CGFloat)proximity
{
    return ceilf((self.autoscrollThreshold - proximity) / 5.0);
}
- (void)determineAutoscrollDistanceForSnapShot
{
    self.autoscrollDistance = 0;
    
    // Check for autoscrolling
    // 1. The content size is bigger than the frame's
    // 2. The snap shot is still inside the table view's bounds
    if ([self canScroll] && CGRectIntersectsRect(self.snapshotOfMovingCell.frame, self.tableView.bounds))
    {
        CGPoint touchLocation = [self.movingGestureRecognizer locationInView:self.tableView];
        touchLocation.y += self.touchOffset.y;
        
        CGFloat distanceToTopEdge = touchLocation.y - CGRectGetMinY(self.tableView.bounds);
        CGFloat distanceToBottomEdge = CGRectGetMaxY(self.tableView.bounds) - touchLocation.y;
        
        if (distanceToTopEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceToTopEdge] * -1;
        }
        else if (distanceToBottomEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceToBottomEdge];
        }
    }
}
- (void)maybeAutoscroll
{
    [self determineAutoscrollDistanceForSnapShot];
    
    if (self.autoscrollDistance == 0)
    {
        [self.autoscrollTimer invalidate];
        self.autoscrollTimer = nil;
    }
    else if (self.autoscrollTimer == nil)
    {
        self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0) target:self selector:@selector(autoscrollTimerFired:) userInfo:nil repeats:YES];
    }
}
- (void)prepareAutoscrollForSnapshot
{
    self.autoscrollThreshold = CGRectGetHeight(self.snapshotOfMovingCell.frame) * 0.6;
    self.autoscrollDistance = 0;
}

@end
