class ConfigError < StandardError
  def initialize(message)
    @message = message
  end
end
