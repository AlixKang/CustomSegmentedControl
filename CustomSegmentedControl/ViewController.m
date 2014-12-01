//
//  ViewController.m
//  CustomSegmentedControl
//
//  Created by Alix on 12/1/14.
//
//

#import "ViewController.h"
#import "CustomSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CustomSegmentedControl *segmentedControl = [[CustomSegmentedControl alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
    [self.view addSubview:segmentedControl];
    
    NSArray *items = @[ @[@"Image1", @"Title1"],
                        @[@"Image2", @"Title2"],
                        @[@"Image3", @"Title3"]];
    
    [segmentedControl setItemsWithArray:items];
    
    // segmentedControl.imageLocation = EImageAtRight;
    
    [segmentedControl addTarget:self
                         action:@selector(valueChanged:)
               forControlEvents:UIControlEventValueChanged];
}

- (IBAction)valueChanged:(CustomSegmentedControl*)sender{
    
    if (sender.isItemFirstSelected == NO) {
        [sender rotateImageWithAnimation:YES];
    }
    
    NSLog(@"CurrentIndex : %ld　radians:%f", (long)sender.currentIndex, sender.imageRadians);
}
@end
