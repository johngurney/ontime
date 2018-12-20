class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    #ActionCable.server.broadcast 'room_channel1', message: render_message(message)

    puts "PERFORM"


    message.myusers.each do |myuser|
      puts "*** Broadcast to user: " + myuser.name + " ***"
      message.encrypt_and_send_message_to_user(myuser)
    end
    #message.encrypt_and_send_message_to_user(User.find(2))

  end

  # private
  #
  #
  # def encrypt_and_encode (key, message)
  #   Base64.encode64(key.public_encrypt(message))
  # end
  #
  # def render_message(message)
  #   message.content = message.content[0,249]
  #   ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  # end
end
