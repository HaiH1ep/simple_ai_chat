class HomeController < ApplicationController

  def index
  end

  def health
    redis_status = Sidekiq.redis(&:ping) == "PONG"
    openai_status = OpenaiService.new.health_check
    render json: {
      redis_status: redis_status,
      openai_status: openai_status
    }, status: :ok
  end
end
