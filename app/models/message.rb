class Message < ApplicationRecord

  has_and_belongs_to_many :myusers
  has_one :action

  after_create_commit { MessageBroadcastJob.perform_later self }

  def encrypt_content_for_save(content)
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key Rails.configuration.encryption_salt, Rails.configuration.encryption_key_length
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.encrypt_and_sign(content)
  end


  def decrypt_content_for_read()
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key Rails.configuration.encryption_salt, Rails.configuration.encryption_key_length
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.decrypt_and_verify(self.encrypted_content)
  end

  def encrypt_with_public_key(key)

    rendered_message =  render_message(self)

    encrypted_encoded_message = ""
    p = 0

    loop do
      if !encrypted_encoded_message.blank?
        encrypted_encoded_message += "\t"
      end
      encrypted_encoded_message += encrypt_and_encode(key , rendered_message[p,100])
      p+=100
      if p >= rendered_message.length
        break
      end

    end

    encrypted_encoded_message

  end

  def encrypt_and_send_message_to_user(user)
    if !user.client_public_key.blank?
      pubkey = user.client_public_key
      key      = OpenSSL::PKey::RSA.new(pubkey)
      ActionCable.server.broadcast 'room_channel' + user.id.to_s, action: "add", message: self.encrypt_with_public_key(key)
    end
  end

  def colour_lookup()
    n=self.colour.to_i
    "#" + ((256 * 256 * 256 - 1) - bitwise_compress(n) * 16 - bitwise_compress(n/2) * (16 * 256) - bitwise_compress(n / 4) * (16  * 256 * 256)).to_s(16)
  end

  def name
    Myuser.find(self.myuser_id).name
  end

  def myusers
    if self.forum_name[0,4] == "task"
      Task.find(self.forum_name.sub!("task", "").to_i).myusers
    elsif self.forum_name[0,3] == "job"
      Job.find(self.forum_name.sub!("job", "").to_i).myusers
    end
  end

private

  def bitwise_compress(value)
    (value & 1) + (value & 8) / 4 + (value & 64) / 16
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, myusers_for_message_forum: Myuser.all })
  end

  def encrypt_and_encode (key, content)
    Base64.encode64(key.public_encrypt(content))
  end



end
