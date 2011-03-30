module NerdNode
  # Rack app to reject common bot attacks.  Returns a random HTTP status and content type, along with some LOLs.
  #
  # Usage:
  #   use NerdNode::BotProtector, /phpmyadmin\/scripts|mysql\/scripts/
  #
  #   # ...or use the Regexp helper which takes an array of URL strings...
  #   blacklist = BotProtector.build_regex(['phpmyadmin/scripts', 'mysql/scripts'])
  #   use NerdNode::BotProtector, blacklist
  #
  #   run Rack::Lobster.new
  class BotProtector

    # Builds and returns a Regexp for the given +blacklist+ array.
    def self.build_regex(blacklist)
      Regexp.new(blacklist.map { |i| Regexp.escape(i) }.join('|'), Regexp::IGNORECASE)
    end

    # * +app+ must be a valid Rack app (or proc).
    # * +blacklist+ should be a Regexp or something that plays nice with this:
    #
    #    if env['PATH_INFO'] =~ blacklist
    #      # ...
    #    end
    #
    # * Set <tt>options[:logger]</tt> to whatever logging facility you're using; it should respond to <tt>warn(String)</tt>.
    def initialize(app, blacklist, options = {})
      @app = app
      @blacklist = blacklist
      @logger = (options[:logger] || options['logger']) || (Rails.logger if defined? Rails)
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      if env['PATH_INFO'] =~ @blacklist
        log_attempt(env)
        @status   = random_status
        @headers  = { 'Content-Type' => random_content_type }
        @response = generate_fake_response
      else
        @status, @headers, @response = @app.call(env)
      end

      [@status, @headers, @response]
    end

    private

    def log_attempt(env)
      ip      = env['REMOTE_ADDR']
      path    = env['PATH_INFO']
      bot_log = BotLog.log_attempt!(ip, path)
      @logger.warn("BOT_PROTECTOR: #{bot_log.message}")
    end

    # TODO: Maybe read from a fortune file or something.
    def generate_fake_response
      "LOL" * 404
    end

    # Return a random HTTP Content-Type.
    def random_content_type
      %w{
        application/javascript
        application/json
        application/octet-stream
        application/pdf
        application/x-tar
        application/zip
        audio/mpeg
        audio/ogg
        image/gif
        image/jpeg
        image/png
        text/csv
        text/html
        text/plain
        text/xml
        video/mpeg
        video/ogg
      }.shuffle.first
    end

    # Return a random HTTP status code between +range+.
    def random_status(range = 400..450)
      range.to_a.shuffle.first
    end

  end # BotProtector
end # NerdNode

