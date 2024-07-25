require "csv"

class ImportCsvController < ApplicationController
  def import_connections
    csv_file = import_connections_params[:csv_file]
    if csv_file.try(:content_type) != "text/csv" && File.extname(csv_file) != ".csv"
      return redirect_to root_path, alert: "Please select a CSV file"
    end

    file_name = csv_file.original_filename.split(".").first

    csv_text = csv_file.read
    csv = CSV.parse(csv_text, headers: false)
    csv_cleanup = CsvCleanup.new(csv)
    data_to_import = csv_cleanup.prepare_data_for_import

    LinkedinConnection.import!(data_to_import)

    data_in_json = csv_cleanup.to_json
    json_file_name = "tmp/#{file_name}_#{Time.now.to_i}.json"
    File.write(json_file_name, data_in_json)
    file = File.open(json_file_name)
    ok, thread_id, assistant_id = OpenaiService.new.execute_init_conversation(file)
    raise "Cannot init conversation" unless ok

    @chat = Chat.create!(thread_id: thread_id, assistant_id: assistant_id)
    redirect_to chat_path(id: @chat.id), notice: "Connections imported successfully."
  rescue StandardError => e
    logger.error("Import failed: #{e.message}")
    redirect_to root_path, alert: e.message
  end

  def import_connections_params
    params.permit(:csv_file)
  end
end
