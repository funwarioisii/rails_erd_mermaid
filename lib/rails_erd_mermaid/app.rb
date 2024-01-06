# frozen_string_literal: true

require_relative "schema_to_mermaid"

module RailsErdMermaid
  class App
    def initialize(config)
      @config = config
    end

    def export
      data = SchemaToMermaid.run

      file_path = "#{@config.dir_name}/#{@config.file_name}.#{@config.filetype}"
      FileUtils.mkdir_p(File.dirname(file_path))
      File.open(file_path, "w") do |f|
        f.write(data.to_s)
      end
    end
  end
end
