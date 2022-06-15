//
//  DetailsViewController.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 6/15/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitle;
@property (weak, nonatomic) IBOutlet UILabel *descriptionSynapsis;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
