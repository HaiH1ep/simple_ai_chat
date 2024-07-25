# spec/services/openai_service_spec.rb
require 'rails_helper'

RSpec.describe OpenaiService, type: :service do
  describe '#execute_init_conversation' do
    it 'initializes a conversation and returns ok, thread_id, and assistant_id' do
      service = OpenaiService.new
      file = double('file')
      allow(service).to receive(:execute_init_conversation).with(file).and_return([true, 'thread123', 'assistant456'])

      ok, thread_id, assistant_id = service.execute_init_conversation(file)

      expect(ok).to be true
      expect(thread_id).to eq('thread123')
      expect(assistant_id).to eq('assistant456')
    end

    it 'returns false when initialization fails' do
      service = OpenaiService.new
      file = double('file')
      allow(service).to receive(:upload_file).with(file).and_raise(StandardError.new('Cannot upload file'))

      ok, thread_id, assistant_id = service.execute_init_conversation(file)
      expect(ok).to be false
      expect(thread_id).to be nil
      expect(assistant_id).to be nil
    end
  end

  describe '#execute_message' do
    it 'returns false when message cannot be found' do
      service = OpenaiService.new
      message_id = 123
      allow(Message).to receive(:find_by).with(id: message_id).and_return(nil)

      expect(service.execute_message(message_id)).to be false
    end
  end
end
