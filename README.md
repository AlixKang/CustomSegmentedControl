## Usage

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(10, 100, 300, 30);
    CustomSegmentedControl *sc = [[CustomSegmentedControl alloc] initWithFrame:frame];
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
```