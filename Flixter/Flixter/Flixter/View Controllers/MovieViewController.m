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
    // Assigning delegate and dataSource elements for the CollectionView to self
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    //    Get all the movies
    [self fetchMovies];
    
//    initalize the refresh control and insert it
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
//               in case of connection error
//               stop activity indicator in both cases
               [self.activityIndicator stopAnimating];
               
//               alert error to the user
               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                    message:[error localizedDescription]
                  preferredStyle:UIAlertControllerStyleAlert];
               
//               default action is to try again
               UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {
                        [self fetchMovies];
                     }];
               
               [alert addAction:defaultAction];
               [self presentViewController:alert animated:YES completion:nil];
               
           }
           else {
//               no connection error
               [self.activityIndicator stopAnimating];
               
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // Assign the movie results to the  movieArray property
               self.movieArray = dataDictionary[@"results"];
               // Reload the data in casa it hasnt come in yet
               [self.tableView reloadData];
               
           }
        
//        end refresh control
        [self.refreshControl endRefreshing];
        
        
       }];
    
    
    
    // 5 - resume the task
    [task resume];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section{
//    return amount of movies in the movieArray
        return self.movieArray.count;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath{
//    initialize cell (MovieCell) to a reusable cell using the MovieCell identifier
    MovieCell *cell = [tableView
    dequeueReusableCellWithIdentifier: @"MovieCell"];
    
//    get the movie and assign title and overview to cell accordingly
    NSDictionary *movie = self.movieArray[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text=movie[@"overview"];
    
//    get the url of the poster image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
//    assign the poser image to the cell
    cell.posterView.image=nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *myIndexPath=self.tableView.indexPathForSelectedRow;

    NSDictionary *dataToPass = self.movieArray[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}

@end
