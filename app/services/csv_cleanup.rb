class CsvCleanup
  MAPPING_HEADERS = ["first name", "last name", "email", "position", "company", "profile url", "url", "connected on"].freeze
  MAPPING_DB_COLUMNS = {
    "url" => "profile_url"
  }

  def initialize(input_csv, user_id = nil)
    @csv = input_csv
    @user_id = user_id
  end

  def prepare_data_for_import
    connection_file_remove_unnecessary_row
    # drop header
    connection_hashed.drop(1)
  end

  def connection_file_remove_unnecessary_row
    # find header row and remove before it
    header_row_index
    # return unless header_row_index
    @csv = @csv&.drop(header_row_index)
  end

  def header_hashed
    header_row_content.map.with_index do |header, index|
      column_name = MAPPING_DB_COLUMNS[header.downcase] || header.downcase.tr(" ", "_")
      [column_name, index] if MAPPING_HEADERS.include? header.downcase
    end.compact.to_h
  end

  def header_row
    @csv.each_with_index do |row, index|
      # fail fast if cannot found header
      raise "cannot find header" if index >= 5

      next if row[0].nil?

      return [index, row] if MAPPING_HEADERS.include? row[0].downcase
    end
    # raise when loop does not get result
    raise "cannot find correct header"
  end

  def header_row_index
    header_row[0]
  end

  def header_row_content
    header_row[1]
  end

  def connection_hashed
    result = @csv.map do |row|
      transformed_row = header_hashed.transform_values { |index| row[index] }
      transformed_row.merge(user_id: @user_id)
    end
    result
  end

  def convert_to_json
    result = @csv.map do |row|
      header_row_content.transform_values { |index| row[index] }
    end
    result
  end
end
