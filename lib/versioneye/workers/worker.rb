class Worker

  require 'bunny'

  def get_connection
    Bunny.new("amqp://#{Settings.instance.rabbitmq_addr}:#{Settings.instance.rabbitmq_port}")
  end

  def self.log
    ActiveSupport::Logger.new('log/worker.log', 10, 2048000)
  end

  def log
    Worker.log
  end

end
