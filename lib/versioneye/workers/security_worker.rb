class SecurityWorker < Worker


  def work
    connection = get_connection
    connection.start
    channel = connection.create_channel
    queue   = channel.queue("security_crawl", :durable => true)

    log_msg = " [*] Waiting for messages in #{queue.name}. To exit press CTRL+C"
    puts log_msg
    log.info log_msg

    begin
      queue.subscribe(:ack => true, :block => true) do |delivery_info, properties, message|
        log_msg = " [x] Received #{message}"
        puts log_msg
        log.info log_msg

        process_work message

        log_msg = "Job done for #{message}"
        puts log_msg
        log.info log_msg

        channel.ack(delivery_info.delivery_tag)
      end
    rescue => e
      log.error e.message
      log.error e.backtrace.join("\n")
      connection.close
    end
  end


  def process_work message
    return nil if message.to_s.empty?

    if message.eql?("node_security")
      NodeSecurityCrawler.crawl
    elsif message.eql?('php_sensiolabs')
      PhpSensiolabsCrawler.crawl
    elsif message.eql?('php_magento')
      PhpMagentoCrawler.crawl
    elsif message.eql?('ruby_security')
      RubySecurityCrawler.crawl
    elsif message.eql?('java_security')
      JavaSecurityCrawler.crawl
    end
  rescue => e
    log.error e.message
    log.error e.backtrace.join("\n")
  end


end
