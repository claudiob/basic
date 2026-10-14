# Runs a job the moment it is enqueued, however far ahead it was asked for.
class ActiveJob::QueueAdapters::ImmediateAdapter < ActiveJob::QueueAdapters::InlineAdapter
  # Runs the job now rather than at the time it names.
  def enqueue_at(job, _timestamp) = enqueue(job)
end
