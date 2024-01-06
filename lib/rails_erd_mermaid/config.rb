# frozen_string_literal: true

module RailsErdMermaid
  class Config
    DEFAULT_CONFIG = {
      filetype: "mermaid",
      dir_name: "mermaid_erd",
      file_name: "erd"
    }.freeze

    attr_reader :filetype, :dir_name, :file_name

    def initialize(**options)
      @filetype = options[:filetype] || DEFAULT_CONFIG[:filetype]
      @dir_name = options[:dir_name] || DEFAULT_CONFIG[:dir_name]
      @file_name = options[:file_name] || DEFAULT_CONFIG[:file_name]
    end
  end
end
