class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board"
    # stream_from "some_channel"
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
