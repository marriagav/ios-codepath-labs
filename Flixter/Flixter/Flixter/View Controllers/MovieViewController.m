//
//  MovieViewController.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *movieArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchMovies {
    
    // 1 - create url
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    
    // 2 - create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // 3 - create session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4 - create our session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Start the activity indicator
        [self.activityIndicator startAnimating];
           if (error != nil) {
               [self.activityIndicator stopAnimating];
               
               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                    message:[error localizedDescription]
                  preferredStyle:UIAlertControllerStyleAlert];
               
               UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {
                        [self fetchMovies];
                     }];
               
               [alert addAction:defaultAction];
               [self presentViewController:alert animated:YES completion:nil];
               
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               [self.activityIndicator stopAnimating];
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               // NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               self.movieArray = dataDictionary[@"results"];
//               for (id movie in self.movieArray) {
//                   NSLog(@"%@", movie);
//               }
               [self.tableView reloadData];
               
           }
        
        [self.refreshControl endRefreshing];
        
        
       }];
    
    
    
    // 5 - resume the task
    [task resume];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section{
        return self.movieArray.count;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath{
    MovieCell *cell = [tableView
    dequeueReusableCellWithIdentifier: @"MovieCell"];
    
    NSDictionary *movie = self.movieArray[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text=movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image=nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    NSLog(@"%@", sender);
    NSIndexPath *myIndexPath=self.tableView.indexPathForSelectedRow;

    NSDictionary *dataToPass = self.movieArray[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    //detailVC.detailDict = dataToPass;
    detailVC.detailDict = dataToPass;
}

@end
