//
//  CYFaceLicenseController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/17.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYFaceLicenseController.h"
#if TARGET_IPHONE_SIMULATOR
#else
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "LivenessViewController.h"
#import "DetectionViewController.h"
#import "LivingConfigModel.h"
#endif

@interface CYFaceLicenseController ()
@property (weak, nonatomic) IBOutlet UIImageView *faceImgView;

@end

@implementation CYFaceLicenseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [CYNotificationCenter addObserver:self selector:@selector(selectedFaceIdImage:) name:CYFaceIDImageKey object:nil];

}

- (IBAction)startLivenseeAction:(UIButton *)sender {
    sender.avoidRepeatEventInterval = 1.f;
    CYLog(@"face id ## ");
#if !(TARGET_IPHONE_SIMULATOR)
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    LivingConfigModel* model = [LivingConfigModel sharedInstance];
    model.liveActionArray = [NSMutableArray arrayWithObjects:@(FaceLivenessActionTypeLivePitchDown),@(FaceLivenessActionTypeLiveMouth), nil];
    model.numOfLiveness = 2;
    [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    CYNavigationController *navi = [[CYNavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
#endif
}


- (void)selectedFaceIdImage:(NSNotification *)notification{
    CYLog(@"nofication : ## %@",notification.object);
    UIImage *image = (UIImage *)notification.object;
    self.faceImgView.image = image;
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
