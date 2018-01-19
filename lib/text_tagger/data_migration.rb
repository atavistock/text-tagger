require 'yaml'

module TextTagger
  class DataMigration

    FILES = %w{unknown tag_context word_probability}
    ROOTDIR = File.expand_path(
      File.join(File.dirname(__FILE__), '..', '..')
    )

    def generate_sql
      FILES.each do |name|
        sql_generator = SqlGenerator.new(name)
        sql_generator.create
      end
    end

    class SqlGenerator

      def initialize(name)
        @sql_table = "text_tagger_#{name}"
        @yaml_file = File.join(ROOTDIR, 'data', "#{name}.yml")
        @sql_file = File.join(ROOTDIR, 'db', "#{@sql_table}.sql")
      end

      def create
        File.open(@sql_file, 'w') do |f|
          f.puts create_table_sql
          f.puts create_insert_sql
        end
      end

      def create_table_sql
        %[
          CREATE TABLE IF NOT EXISTS #{@sql_table} (
            key VARCHAR NOT NULL,
            tag VARCHAR NOT NULL,
            value NUMERIC
          );
          CREATE UNIQUE INDEX idx_uniq_#{@sql_table} ON #{@sql_table}(key, tag);
          CREATE INDEX idx_#{@sql_table} ON #{@sql_table}(key);
        ].gsub(/\n\s{10}/, "\n")
      end

      def create_insert_sql
        inserts = []
        yaml = YAML.load_file(@yaml_file)
        yaml.each do |key, data|
          data.each do |tag, value|
            inserts << "('#{quote(key)}', '#{quote(tag)}', #{"%0.10f" % value})"
          end
        end
        "INSERT INTO #{@sql_table}(key, tag, value) VALUES\n  #{inserts.join(",\n  ")}"
      end

      def quote(s)
        # if ActiveRecord::Base.connection
        #   ActiveRecord::Base.connection.quote_string(s)
        # else
          s.to_s.gsub('\\', '\&\&').gsub("'", "''")
        # end
      end

    end

  end
end