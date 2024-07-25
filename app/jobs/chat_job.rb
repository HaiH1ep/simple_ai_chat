class ChatJob
  include Sidekiq::Job

  def perform(message_id)
    OpenaiService.new.execute_message(message_id)
  end
end
