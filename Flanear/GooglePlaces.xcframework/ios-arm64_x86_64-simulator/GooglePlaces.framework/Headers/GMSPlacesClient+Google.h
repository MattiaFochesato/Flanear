//
//  GMSPlacesClient+Google.h
//  Google Places SDK for iOS
//
//  Copyright 2016 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import "GMSPlacesClient.h"

#import "GMSAutocompleteFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMSPlacesClient ()

/**
 * Find place likelihoods for a specified location. This method is non-blocking.
 *
 * The supplied callback will be invoked with an array of places with likelihood scores upon success
 * and an NSError upon an error.
 *
 * @param location The location to base the place estimate on.
 * @param placeFields The individual place fields requested for the place objects in the list.
 * @param callback The callback to invoke with place likelihoods.
 */
- (void)findPlaceLikelihoodsForLocation:(CLLocation *)location
                            placeFields:(GMSPlaceField)placeFields
                               callback:(GMSPlaceLikelihoodListCallback)callback;

@end

NS_ASSUME_NONNULL_END
