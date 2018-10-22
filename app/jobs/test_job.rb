class TestJob
  include SuckerPunch::Job
  
  def perform
    
    Rails.cache.write("beer top 3", Beer.top(3))
    Rails.cache.write("brewery top 3", Brewery.top(3))
    Rails.cache.write("user top 3", User.top(3))
    Rails.cache.write("style top 3", Style.top(3))
    Rails.cache.write("rating recent", Rating.recent)

    TestJob.perform_in(10.minutes)
  end
end