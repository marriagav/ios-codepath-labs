//
//  TipViewController.m
//  Tipster
//
//  Created by Miguel Arriaga Velasco on 6/14/22.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipSegCtrl;
@property (weak, nonatomic) IBOutlet UITextField *billField;

@end

@implementation TipViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onTap:(id)sender {
    NSLog(@"Tapped");
    [self.view endEditing:true];
}
- (IBAction)updateTotal:(id)sender {
    double tipPercentages[] = {0.10, 0.15, 0.20};
    double selectedTipPercent = tipPercentages[self.tipSegCtrl.selectedSegmentIndex];
    
    double billPreTip=self.billField.text.doubleValue;
    double tipAmount = selectedTipPercent * billPreTip;
    double totalAmount = tipAmount + billPreTip;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
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
