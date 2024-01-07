# frozen_string_literal: true

require "thor"
require_relative "app"
require_relative "config"

module RailsErdMermaid
  class CLI < Thor
    default_command :export

    desc "export", "Generate a mermaid file from your database"
    option :filetype, default: "mermaid", desc: "Filetype to export. It is used for file extension."
    option :dir_name, default: "mermaid_erd", desc: "Directory name to export"
    option :file_name, default: "erd", desc: "File name to export"
    def export
      config = Config.new(**options)
      app = App.new(config)
      app.run
    end
  end
end
