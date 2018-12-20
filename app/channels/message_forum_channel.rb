class MessageForumChannel < ApplicationCable::Channel

  # Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.

    def subscribed
      stream_from 'room_channel' + uuid.id.to_s
      #   puts "********************"
      #   ActionCable.server.connections.each do |connection|
      #     puts ">>>" + connection.uuid.id.to_s
      #   end
      #   transmit message
      # end
    end

    def unsubscribed
      puts "unsubsribed"
      # Any cleanup needed when channel is unsubscribed
    end

    def request_past_messages(data)
       puts "******  request_past_messages *********"

      pubkey = uuid.client_public_key

      key      = OpenSSL::PKey::RSA.new(pubkey)

      encrypted_encoded_message = ""
      message_number = data["message_number"]
      message_forum_name = data["message_forum_name"]
      puts "*** FORUM NAME ***" + message_forum_name


      messages_for_forum=Message.where(:forum_name => message_forum_name)

      if Message.count > 0

        if message_number == "newest"
          allow_new_messages ="yes"
          messages = messages_for_forum.order("created_at DESC").limit(10)
          next_messages ="newest"
          if messages.count > 0
            previous_messages = messages.maximum("number") - 10
          else
            previous_messages = 0
          end
        elsif message_number == "oldest"
          allow_new_messages ="no"
          messages = messages_for_forum.where("number <= 10").limit(10).order("created_at DESC")
          next_messages = 20
          previous_messages = "oldest"
        else
          allow_new_messages ="no"
          n = message_number.to_i
          messages = messages_for_forum.where("number > ? AND number <= ? ", n-10, n).limit(10).order("created_at DESC")
          next_messages = n + 10
          previous_messages = n - 10
        end

        previous_messages = "oldest" if previous_messages.to_i < 0
        next_messages  = "newest" if next_messages.to_i > Message.maximum("number")

        messages.each do |message|
          if !encrypted_encoded_message.blank?
            encrypted_encoded_message += "\t\n"
          end
          encrypted_encoded_message += message.encrypt_with_public_key(key)
        end
      else
        encrypted_encoded_message = ""
      end

      packet_length=7500

      if encrypted_encoded_message.length < packet_length
        ActionCable.server.broadcast 'room_channel' + uuid.id.to_s, action: "all", allow_new_messages: allow_new_messages, message: encrypted_encoded_message, previous_messages: previous_messages, next_messages: next_messages
      else
        total_no_packets = (encrypted_encoded_message.length / packet_length) + 1

        # broadcast first packet
        ActionCable.server.broadcast 'room_channel' + uuid.id.to_s, action: "all", allow_new_messages: allow_new_messages, \
          message: encrypted_encoded_message[0,packet_length], previous_messages: previous_messages, next_messages: next_messages, packet_number: 0, total_no_packets:  total_no_packets

          # broadcast remaining packets
        (1..total_no_packets - 1).each do |packet_number|
          puts "*******" + packet_number.to_s
          ActionCable.server.broadcast 'room_channel' + uuid.id.to_s, message: encrypted_encoded_message[packet_number * packet_length ,packet_length], packet_number: packet_number,  total_no_packets: total_no_packets
        end
      end
      # User.find(1).send_content_to_user(encrypted_encoded_message)
      # User.find(2).send_content_to_user(encrypted_encoded_message)

    end

    def client_public_key(data)
      #Receive client's public key

      #Receive client key
      client_public_key = data['key']
      uuid.client_public_key = client_public_key

      #Generate server key
      server_key = OpenSSL::PKey::RSA.new(2048)
      server_public_key = server_key.public_key.to_pem
      server_key = server_key.to_pem
      ActionCable.server.broadcast 'room_channel'+uuid.id.to_s, server_public_key: server_public_key
      uuid.server_private_key = server_key

      uuid.save

      # private_key = data['private_key']
      # message = data['message']
      # puts "Public key +++++" + public_key
      # puts "Private key +++++" + private_key
      # key = OpenSSL::PKey::RSA.new(2048)
      #
      # #message  = 'dan is really really clever'
      # key      = OpenSSL::PKey::RSA.new(private_key)
      # #encrypted_message = message
      # #key      = OpenSSL::PKey::RSA.new(2048)
      # result = key.public_encrypt(message)
      # result_encoded = Base64.encode64(result)
      # puts "Locally encrypted message:" + result_encoded.to_s
      #
      # result1 = key.private_decrypt(result)
      # puts "Locally decrypted message:" + result1
      #
      # #
      # #
      # # encrypted_message = data['encrypted_message']
      # #
      # # message = data['message']
      # # puts "Remotely encrypted message:" + encrypted_message
      # # result = key.private_encrypt(message)
      #
      # result_encoded = Base64.encode64(result)
      # puts "Locally encrypted message:" + result_encoded.to_s
      #
      # result1 = key.private_decrypt(result)
      # puts "Message:" + result1.to_s

    end

    def message(data)
      puts "********* SPEAK *********"
      if !uuid.blank?
        private_key = OpenSSL::PKey::RSA.new(uuid.server_private_key)
        encoded_encrypted_message = data['message']

        unencrypted_message  = private_key.private_decrypt(Base64.decode64(encoded_encrypted_message))
        message_forum_name = data["message_forum_name"]

        puts "message_forum_name:" + message_forum_name

        key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key Rails.configuration.encryption_salt, Rails.configuration.encryption_key_length
        crypt = ActiveSupport::MessageEncryptor.new(key)
        encrypted_message = crypt.encrypt_and_sign(unencrypted_message)

        if Message.count == 0
          colour=1
        else
          if Message.where(myuser_id: uuid.id).count ==0
            colour=Message.maximum("colour")+1
          else
            colour=Message.where(myuser_id: uuid.id).first.colour
          end
        end

        Message.create! encrypted_content: encrypted_message , myuser_id: uuid.id, number: Message.maximum("number").to_i + 1, colour: colour, forum_name: message_forum_name


      end
    end

    def action(data)
      private_key = OpenSSL::PKey::RSA.new(uuid.server_private_key)
      encoded_encrypted_action = data['action_text']

      unencrypted_action  = private_key.private_decrypt(Base64.decode64(encoded_encrypted_action))

      message_number = data['message_number']
      action_myusers = data['action_myusers']
      action_date = data['action_date']

      if Action.where(message_id: message_number).count==0
        action = Action.new
        action.message_id = message_number
      else
        action =  Action.where(message_id: message_number).first
      end

      action.content = unencrypted_action

    #    action.do_date = ActiveSupport::TimeZone.parse(params[:action_date]) if params[:action_date]
      action.do_date = DateTime.parse action_date rescue Date.today() if action_date

      action.myusers.clear
      action_myusers.split(";").each do |myuser_id|
        if myuser_id.to_i != 0
          action.myusers << Myuser.find(myuser_id.to_i)
        end
      end
      action.save

    end


  end
