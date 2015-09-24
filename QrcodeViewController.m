//
//  QrcodeViewController.m
//  qx
//
//  Created by wayos-ios on 12/2/14.
//  Copyright (c) 2014 webuser. All rights reserved.
//

#import "QrcodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QrcodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession *_session;
    void (^_sucBlock)(NSString *);
}

@end

@implementation QrcodeViewController

- (instancetype) initWithSucBlock:(void (^)(NSString *))sucBlock{
    if (self = [super init]) {
        _sucBlock = sucBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    //这个必须在后面, 不知道为啥
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity  = AVLayerVideoGravityResizeAspectFill;
    layer.frame = CGRectMake(0, 20, 320, 200);
    [self.view.layer insertSublayer:layer atIndex:0];
    [_session startRunning];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(50, 240, 220, 40);
    cancelBtn.backgroundColor = [UIColor blueColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(_cancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
        [_session stopRunning];
        _sucBlock(metadataObject.stringValue);
    }
}

- (void) _cancel{
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
