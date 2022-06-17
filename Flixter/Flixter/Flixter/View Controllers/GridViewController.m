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
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Assigning delegate and dataSource elements for the CollectionView to self
    self.collectionView.dataSource = self;
    self.collectionView.delegate=self;
    
//    Get all the movies
    [self fetchMovies];
    
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
//               in case of connection error
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
//               no connection error
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

//               Assign the movie results to the  movieArray property
               self.movieArray = dataDictionary[@"results"];
//               Reload the data in casa it hasnt come in yet
               [self.collectionView reloadData];
               
           }
        
        
       }];
    
    // 5 - resume the task
    [task resume];
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return number of movies in array
    return self.movieArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    Initialize cell to an instance of a PosterCell using the identifier of the posterImageCell
    PosterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"posterImageCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movieArray[indexPath.row];

//    Get the url of the poster and set it to the cell image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";

    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];

    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterImage.image=nil;
    [cell.posterImage setImageWithURL:posterURL];

    return cell;
}

- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];
//    programmatically set the flowlayout settings
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 3;
    self.flowLayout.minimumInteritemSpacing = 3;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 25);
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
