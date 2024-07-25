class OpenaiService
  OPENAI_MODEL = "gpt-4o-mini".freeze

  def initialize
    @client = OpenAI::Client.new
  end

  def execute_init_conversation(file)
    ok, file_id = upload_file(file)
    raise "Cannot upload file" unless ok

    ok_vector, vector_id = create_vector_store(file_id)
    raise "Cannot create vector store" unless ok_vector

    ok_assistant, assistant_id = create_assistant(vector_id)
    raise "Cannot create assistant" unless ok_assistant

    ok_thread, thread_id = create_thread
    raise "Cannot create thread" unless ok_thread

    [true, thread_id, assistant_id]
  rescue StandardError => e
    Rails.logger.error("Failed to execute init conversation: #{e.message}")
    [false, nil, nil]
  end

  def execute_message(message_id)
    message = Message.find_by(id: message_id)
    raise "Cannot find message" unless message
    raise "Need content" unless message.content

    chat = message.chat
    raise "Cannot find chat" unless chat

    thread_id = chat.thread_id
    raise "Cannot find thread ID" unless thread_id

    assistant_id = chat.assistant_id
    raise "Cannot find assistant ID" unless assistant_id

    send_message(content: message.content, thread_id: thread_id)
    ok, run_id = run_assistant(assistant_id: assistant_id, thread_id: thread_id)
    raise "Cannot run assistant" unless ok

    status, response = pooling_for(run_id: run_id, thread_id: thread_id)
    raise "Assistant failed to run: #{response}" unless status == 'completed'

    retrieve_new_messages(run_id: run_id, thread_id: thread_id, last_message_id: message_id)
    true
  rescue StandardError => e
    Rails.logger.error("Failed to execute message: #{e.message}")
    false
  end

  def health_check
    response = @client.models.list
    response["data"].present?
  rescue => e
    Rails.logger.error("OpenAI API error: #{e.message}")
    false
  end

  private

  def create_assistant(vector_id)
    response = @client.assistants.create(
      parameters: {
          model: OPENAI_MODEL,
          name: "Assistant for file #{vector_id}",
          description: nil,
          instructions: "Answer the question for file uploaded",
          tools: [
              { type: "file_search" }
          ],
          tool_resources: {
            file_search: {
              vector_store_ids: [vector_id] # See Vector Stores section above for how to add vector stores
            }
          },
          "metadata": { my_internal_version_id: "1.0.0" }
      })
    assistant_id = response["id"]
    [assistant_id.present?, assistant_id]
  end

  def create_thread
    response_thread = @client.threads.create
    thread_id = response_thread["id"]
    [thread_id.present?, thread_id]
  rescue StandardError => e
    Rails.logger.error("Failed to create thread: #{e.message}")
    [false, nil]
  end

  def send_message(content:, thread_id:)
    @client.messages.create(
      thread_id: thread_id,
      parameters: {
        role: "user",
        content: content
      }
    )
  end

  def run_assistant(assistant_id:, thread_id:)
    response_run = @client.runs.create(thread_id: thread_id,
      parameters: {
        assistant_id: assistant_id
      }
    )
    run_id = response_run['id']
    [run_id.present?, run_id]
  end

  def pooling_for(run_id:, thread_id:)
    while true do
      response = @client.runs.retrieve(id: run_id, thread_id: thread_id)
      status = response['status']

      case status
      when 'queued', 'in_progress', 'cancelling'
        puts 'Sleeping'
        sleep 2 # Wait one second and poll again
      when 'completed'
        break # Exit loop and report result to user
      when 'requires_action'
        # Handle tool calls (see below)
      when 'cancelled', 'failed', 'expired'
        puts response['last_error'].inspect
        break # or `exit`
      else
        puts "Unknown status response: #{status}"
      end
    end
    response = @client.runs.retrieve(id: run_id, thread_id: thread_id)
    [response['status'], response]
  end

  def retrieve_all_messages(thread_id:)
    @client.messages.list(thread_id: thread_id, parameters: { order: 'asc' })
  end

  def retrieve_new_messages(run_id:, thread_id:, last_message_id:)
    run_steps = @client.run_steps.list(thread_id: thread_id, run_id: run_id, parameters: { order: 'asc' })
    new_message_ids = run_steps['data'].filter_map { |step|
      if step['type'] == 'message_creation'
        step.dig('step_details', "message_creation", "message_id")
      end # Ignore tool calls, because they don't create new messages.
    }

    # Retrieve the individual messages
    new_messages = new_message_ids.map { |msg_id|
      @client.messages.retrieve(id: msg_id, thread_id: thread_id)
    }

    # Find the actual response text in the content array of the messages
    new_messages.each { |msg|
      msg['content'].each { |content_item|
        case content_item['type']
        when 'text'
            puts content_item.dig('text', 'value')
            create_message!(thread_id: thread_id, content: content_item.dig('text', 'value'))
            # Also handle annotations
        when 'image_file'
            # Use File endpoint to retrieve file contents via id
            id = content_item.dig('image_file', 'file_id')
            create_message!(thread_id: thread_id, content: "Image file with id: #{id}")
        end
      }
    }
  end

  def create_vector_store(file_id)
    response = @client.vector_stores.create(
      parameters: {
        name: "vector for #{file_id}",
        file_ids: [file_id]
      }
    )

    vector_store_id = response["id"]
    [vector_store_id.present?, vector_store_id]
  end

  def upload_file(file)
    response = @client.files.upload(
      parameters: {
        file: file,
        purpose: "assistants"
      }
    )
    file_id = response["id"]
    [file_id.present?, file_id]
  end

  def create_message!(thread_id:, content:)
    chat = Chat.find_by(thread_id: thread_id)
    raise "Cannot find chat" unless chat

    chat.messages.create(role: "assistant", content: content)
  end
end
