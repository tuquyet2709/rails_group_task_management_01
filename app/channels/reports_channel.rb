class ReportsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "report_channel"
  end
end
