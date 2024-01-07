# frozen_string_literal: true

module RailsErdMermaid
  class SchemaToMermaid
    module IntermediateRepresentation
      Data = Struct.new(:models, :associations) do
        def to_s
          lines = []
          lines << "erDiagram"
          models.each do |model|
            model.to_s.split("\n").each do |line|
              lines << "  #{line}"
            end
          end
          associations.each do |association|
            lines << "  #{association}"
          end

          lines.join("\n")
        end
      end
      Model = Struct.new(:name, :table_name, :columns) do
        def to_s
          lines = []
          lines << "#{name} {"
          columns.each do |column|
            lines << "  #{column}"
          end
          lines << "}"

          lines.join("\n")
        end
      end
      Column = Struct.new(:name, :type, :key) do
        def to_s
          "#{name} #{type} #{key}"
        end
      end

      # https://mermaid.js.org/syntax/entityRelationshipDiagram.html#entities-and-relationships より
      # <first-entity> [<relationship> <second-entity> : <relationship-label>]
      # relationship
      # |Value (left)|Value (right)|Meaning|
      # |---|---|---|
      # |`|o`|`o|`|Zero or one|
      # |`||`|`||`|Exactly one|
      # |`}|o{`|`o{`|Zero or more (no upper limit)|
      # |`}|{`|`|{`|One or more (no upper limit)|
      Association = Struct.new(
        :left_model_name,
        :left_value,
        :right_model_name,
        :right_value,
        :label,
        keyword_init: true
      ) do
        def to_s
          "#{left_model_name} #{left_value}--#{right_value} #{right_model_name} : #{label}"
        end
      end
    end

    def self.run
      new.run
    end

    def run
      data = IntermediateRepresentation::Data.new([], [])
      ::Rails.application.eager_load!
      tables = ::ActiveRecord::Base.connection.tables
      ::ActiveRecord::Base.descendants.sort_by(&:name).each do |model|
        next unless tables.include?(model.table_name)

        foreign_keys = ::ActiveRecord::Schema.foreign_keys(model.table_name).map { |k| k.options[:column] }
        data.models << IntermediateRepresentation::Model.new(
          model.name,
          model.table_name,
          model.columns.map do |column|
            IntermediateRepresentation::Column.new(
              column.name,
              column.type,
              if column.name == model.primary_key
                "PK"
              elsif foreign_keys.include?(column.name)
                "FK"
              else
                ""
              end
            )
          end
        )

        model.reflect_on_all_associations(:has_many).each do |reflection|
          next if reflection.options[:through]

          # example: Model has_many :ReflectedModel
          # Model ||--o{ ReflectedModel : "has many"
          data.associations << IntermediateRepresentation::Association.new(
            left_model_name: model.name,
            left_value: "||",
            right_model_name: reflection.class_name,
            right_value: "o{",
            label: '"has many"'
          )
        end

        model.reflect_on_all_associations(:belongs_to).each do |reflection|
          # example: Model belongs_to :ReflectedModel
          # Model }o--|| ReflectedModel : "belongs to"
          data.associations << IntermediateRepresentation::Association.new(
            left_model_name: model.name,
            left_value: "}o",
            right_model_name: reflection.class_name,
            right_value: "||",
            label: '"belongs to"'
          )
        end

        model.reflect_on_all_associations(:has_one).each do |reflection|
          # example: Model has_one :ReflectedModel
          # Model ||--o| ReflectedModel : "belongs to"
          data.associations << IntermediateRepresentation::Association.new(
            left_model_name: model.name,
            left_value: "||",
            right_model_name: reflection.class_name,
            right_value: "o|",
            label: '"has one"'
          )
        end
      end

      data
    end
  end
end
