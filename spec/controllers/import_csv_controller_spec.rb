require 'rails_helper'
require 'tempfile'

RSpec.describe ImportCsvController, type: :controller do
  describe 'POST #import_connections' do
    let(:csv_file) do
      Tempfile.new(['sample', '.csv']).tap do |file|
        file.write("first name,last name,email,position\nHai Hiep,Nguyen,nguyenhaihiep11@gmail.com,developer")
        file.rewind
      end
    end

    let(:invalid_csv_file) do
      Tempfile.new(['sample', '.csv']).tap do |file|
        file.write("test1,test2\nHai Hiep,Nguyen")
        file.rewind
      end
    end

    let(:invalid_file) do
      Tempfile.new(['sample', '.txt']).tap do |file|
        file.write("This is a text file, not a CSV.")
        file.rewind
      end
    end
    let(:params) { { csv_file: Rack::Test::UploadedFile.new(csv_file.path, 'text/csv') } }
    let(:invalid_csv_params) { { csv_file: Rack::Test::UploadedFile.new(invalid_csv_file.path, 'text/csv') } }
    let(:invalid_params) { { csv_file: Rack::Test::UploadedFile.new(invalid_file.path, 'text/plain') } }

    before do
      allow_any_instance_of(OpenaiService).to receive(:execute_init_conversation).and_return([true, 'thread_id', 'assistant_id'])
    end

    context 'with valid CSV file' do
      it 'imports connections and redirects to chat path' do
        post :import_connections, params: params

        chat = Chat.last
        expect(response).to redirect_to(chat_path(id: chat.id))
        expect(flash[:notice]).to eq('Connections imported successfully.')
        expect(chat.thread_id).to eq('thread_id')
        expect(chat.assistant_id).to eq('assistant_id')
      end
    end

    context 'with invalid CSV file' do
      it 'imports connections and redirects to chat path' do
        post :import_connections, params: invalid_csv_params

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('cannot find correct header')
      end
    end

    context 'with invalid file type' do
      it 'redirects to linkedin connections path with alert' do
        post :import_connections, params: invalid_params

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Please select a CSV file')
      end
    end

    context 'when an error occurs' do
      before do
        allow(LinkedinConnection).to receive(:import!).and_raise(StandardError, 'Import failed')
      end

      it 'rescues the error and redirects to chat path with alert' do
        post :import_connections, params: params

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Import failed')
      end
    end
  end
end
