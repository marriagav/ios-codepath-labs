//
//  DetailsViewController.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 6/15/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitle;
@property (weak, nonatomic) IBOutlet UILabel *descriptionSynapsis;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.descriptionTitle.text=self.detailDict[@"title"];
    self.descriptionSynapsis.text=self.detailDict[@"overview"];
    
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.detailDict[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    self.descriptionImage.image=nil;
    [self.descriptionImage setImageWithURL:posterURL];
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
