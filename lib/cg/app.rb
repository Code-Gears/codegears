require "singleton"
require "cg/api"

module CG
  class APP
    include Singleton

    attr_accessor :secret_id, :secret_token, :id, :channel, :message, :sent, :response

    def self.configure
      yield(self.instance)
    end

    def self.id
      self.instance.id
    end

    def self.secret_id
      self.instance.secret_id
    end

    def self.secret_token
      self.instance.secret_token
    end

    def self.init_message
      yield(self.instance)
      self.instance
    end

    def self.message
      self.instance.message
    end

    def self.channel
      self.instance.channel
    end

    def self.sent?
      !!self.instance.sent
    end

    def self.response
      self.instance.response
    end

    def self.push(channel, message = nil)
      instance = self.instance

      instance.channel = instance.perform(channel)
      instance.message = message || yield

      instance.response = CG::API.push_message_request(instance.channel, instance.message)
    end

    def self.stats
      instance = self.instance

      CG::API.show_app_request(instance.id, instance.secret_id, instance.secret_token)
    end

    def channel=(ch)
      @channel = perform(ch)
    end

    def push
      instance.response = CG::API.push_message_request(channel, message)
    end

    def perform(channel)
      channel[0] == "/" ? channel : "/#{channel}"
    end
  end
end
