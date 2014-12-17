function [ rating_tags ] = grabHtlRatingTags( hotel )
%GRABHTLRATINGTAGS Summary of this function goes here
%   Detailed explanation goes here

	rating_tags={};
	for ii=1:hotel.numReviews
		rating_tags=union(rating_tags,fieldnames...
			(hotel.Reviews{ii}.Ratings));
	end


end

