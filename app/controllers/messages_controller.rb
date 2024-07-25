class MessagesController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @message = Message.new(message_params.merge(role: "user", chat_id: params[:chat_id]))

    if @message.save
      ChatJob.perform_async(@message.id)
    else
      binding.pry
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :chat_id)
  end
end
