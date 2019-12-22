//
//  CYLocalizationController.m
//  MyDome_OC
//
//  Created by zcy on 2019/6/5.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYLocalizationController.h"

@interface CYLocalizationController ()
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;

@end

@implementation CYLocalizationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeMainView];
}

- (void)makeMainView {
    self.view.backgroundColor = [UIColor yellowColor];
}

- (IBAction)clickBtnAction:(UIButton *)sender {
    if (sender.tag == 100) {
        _lab1.text = NSLocalizedString(@"lab1_tag0", nil);
        _lab2.text = NSLocalizedString(@"lab2_tag0", nil);
        _lab3.text = NSLocalizedString(@"lab3_tag0", nil);
        sender.tag = 0;
    }else {
        _lab1.text = NSLocalizedString(@"lab1_tag100", nil);
        _lab2.text = NSLocalizedString(@"lab2_tag100", nil);
        _lab3.text = NSLocalizedString(@"lab3_tag100", nil);
        sender.tag = 100;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
