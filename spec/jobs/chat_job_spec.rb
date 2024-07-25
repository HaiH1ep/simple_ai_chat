require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ChatJob, type: :job do
  before do
    Sidekiq::Testing.fake!
  end

  let(:message_id) { 123 }

  describe '#perform' do
    it 'enqueues the job' do
      expect {
        ChatJob.perform_async(message_id)
      }.to change(ChatJob.jobs, :size).by(1)
    end

    it 'executes the OpenaiService with the correct message_id' do
      openai_service = instance_double(OpenaiService)
      allow(OpenaiService).to receive(:new).and_return(openai_service)
      expect(openai_service).to receive(:execute_message).with(message_id)

      ChatJob.new.perform(message_id)
    end
  end
end
