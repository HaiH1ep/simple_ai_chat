class ChatsController < ApplicationController

  def show
    @chat = resource
    render "show"
  end

  private

  def resource
    Chat.find(params[:id])
  end
end
