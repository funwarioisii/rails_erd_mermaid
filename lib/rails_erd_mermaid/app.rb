# frozen_string_literal: true

require_relative "schema_to_mermaid"

module RailsErdMermaid
  class App
    def initialize(config)
      @config = config

      path = Dir.pwd
      environment_path = "#{path}/config/environment.rb"
      require environment_path

      Rails.application.eager_load!
    end

    def run
      data = SchemaToMermaid.run

      if @config.filetype == "stdout"
        puts data
        return
      end

      file_path = "#{@config.dir_name}/#{@config.file_name}.#{@config.filetype}"
      FileUtils.mkdir_p(File.dirname(file_path))
      File.open(file_path, "w") do |f|
        f.write(data.to_s)
      end
    end
  end
end
