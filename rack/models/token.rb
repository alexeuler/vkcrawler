class Token < ActiveRecord::Base
  def time_left
    created_at+expires-Time.now
  end
end
