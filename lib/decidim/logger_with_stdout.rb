module Decidim
  class LoggerWithStdout < Logger
    def initialize(file_path, verbose: false)
      super(file_path)
      @verbose = verbose
      @stdout_logger = Logger.new($stdout)
    end

    def add(severity, message = nil, progname = nil, &block)
      super

      @stdout_logger.add(severity, message, progname, &block) if @verbose
    end
  end
end