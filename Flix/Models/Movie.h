//
//  Movie.h
//  Flix
//
//  Created by Sebastian Saldana Cardenas on 30/06/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic, weak) NSString *movieId;
@property (nonatomic,strong) NSString *synopsis;
@property (nonatomic,strong) NSString *posterPath;
@property (nonatomic,strong) NSString *releaseDate;
@property (nonatomic,strong) NSURL *lowResPosterUrl;
@property (nonatomic,strong) NSURL *hiResPosterUrl;
@property (nonatomic,strong) NSURL *backdropURL;


-(id)initWithDictionary:(NSDictionary *) dictionary;

+(NSMutableArray*)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
