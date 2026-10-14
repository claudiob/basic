# Base class for all background jobs.
class ApplicationJob < ActiveJob::Base
  sidekiq_retry_in { |count, exception, jobhash| 1.hour * (count + 1) }
  discard_on ActiveJob::DeserializationError
end
