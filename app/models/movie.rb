#class Movie < ActiveRecord::Base
#end

#class Movie < ActiveRecord::Base
#    def self.mpaa_ratings
#        self.select(:rating).map(&:rating).uniq
#    end
#end

class Movie < ActiveRecord::Base
	@all_ratings = ['G','PG','PG-13','R']
	
	def self.all_ratings
		return @all_ratings
	end
end