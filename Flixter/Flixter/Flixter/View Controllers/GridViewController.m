//
//  GridViewController.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 6/16/22.
//

#import "GridViewController.h"
#import "PosterCell.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movieArray;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate=self;
    
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
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               // NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               self.movieArray = dataDictionary[@"results"];
               for (id movie in self.movieArray) {
                   NSLog(@"%@", movie);
               }
               [self.collectionView reloadData];
               
           }
        
        
       }];
    
    // 5 - resume the task
    [task resume];
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movieArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    PosterCell *cell = [collectionView
//    dequeueReusableCellWithIdentifier: @"posterImageCell"];
    
    NSDictionary *movie = self.movieArray[indexPath.row];
    
    PosterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"posterImageCell" forIndexPath:self.movieArray[indexPath.item]];

    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";

    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];

    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterImage=nil;
    [cell.posterImage setImageWithURL:posterURL];

    return cell;
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
