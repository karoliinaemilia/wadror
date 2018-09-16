module RatingAverage
    extend ActiveSupport::Concern
    
    def average_rating
        "%.3g" % (ratings.reduce(0) {|sum, rating| sum+rating.score} / ratings.size.to_f)
    end
end