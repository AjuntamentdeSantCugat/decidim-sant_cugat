# frozen_string_literal: true

require "seven_zip_ruby"

module Decidim
  # Public: Generates a 7z(seven zip) file with data files ready to be persisted
  # somewhere so users can download their data.
  #
  # In fact, the 7z file wraps a ZIP file which finally contains the data files.
  class DataPortabilityExporter
    DEFAULT_EXPORT_FORMAT = "CSV"
    ZIP_FILE_NAME = "data-portability.zip"

    # Public: Initializes the class.
    #
    # user          - The user to export the data from.
    # path          - The String path where to write the zip file.
    # password      - The password to protect the zip file.
    # export_format - The format of the data files inside the zip file. (CSV by default)
    def initialize(user, path, password, export_format = DEFAULT_EXPORT_FORMAT)
      @user = user
      @path = File.expand_path path
      @export_format = export_format
      @password = password
    end

    def export
      dirname = File.dirname(@path)
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
      File.open(@path, "wb") do |file|
        SevenZipRuby::Writer.open(file, password: @password) do |szw|
          szw.header_encryption = true
          szw.add_data(data, ZIP_FILE_NAME)
        end
      end
    end

    private

    def data
      buffer = Zip::OutputStream.write_buffer do |out|
        user_data, attachments = data_for(@user, @export_format)

        add_user_data_to_zip_stream(out, user_data)
        add_attachments_to_zip_stream(out, attachments)
      end

      buffer.string
    end

    def data_for(user, format)
      export_data = []
      export_attachments = []

      data_portability_entities.each do |object|
        klass = Object.const_get(object)
        export_data << [klass.model_name.name.parameterize.pluralize, Exporters.find_exporter(format).new(klass.user_collection(user), klass.export_serializer).export]
        attachments = klass.data_portability_images(user).flatten
        export_attachments << [klass.model_name.name.parameterize.pluralize, attachments] unless attachments.nil?
      end

      [export_data, export_attachments]
    end

    def data_portability_entities
      @data_portability_entities ||= DataPortabilitySerializers.data_entities
    end

    def add_user_data_to_zip_stream(out, user_data)
      user_data.each do |element|
        filename_file = element.last.filename(element.first.parameterize)

        out.put_next_entry(filename_file)
        if element.last.read.presence
          out.write element.last.read
        else
          out.write "No data"
        end
      end
    end

    def add_attachments_to_zip_stream(out, export_attachments)
      export_attachments.each do |attachment_block|
        next if attachment_block.last.nil?

        folder_name = attachment_block.first.parameterize
        attachment_block.last.each do |attachment|
          next if attachment.file.nil?

          case attachment.file.fog_provider
          when "fog" # file system
            my_path = attachment.file.file
            next unless File.exist?(my_path)
            retrieve_and_cache_image_from_filesystem(attachment)
          when "fog/aws"
            retrieve_and_cache_attachment_from_aws(attachment)
          else
            Rails.logger.info "Carrierwave fog_provider not supported by DataPortabilityExporter for attachment: #{attachment.attributes}"
            next
          end

          out.put_next_entry("#{folder_name}/#{attachment.file.filename}")
          File.open(attachment.file.file) do |f|
            out << f.read
          end
          CarrierWave.clean_cached_files!
        end
      end
    end

    def retrieve_and_cache_image_from_filesystem(uploader, attachment)
      uploader = ApplicationUploader.new(attachment.model, attachment.mounted_as)
      uploader.cache!(File.open(attachment.file.file))
      uploader.retrieve_from_store!(attachment.file.filename)
    end

    def retrieve_and_cache_attachment_from_aws(uploader, attachment)
      uploader = attachment.file
      uploader.cache_stored_file!
      uploader.retrieve_from_cache!(uploader.cache_name)
    end

  end
end
