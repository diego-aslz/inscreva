require 'zip/zip'

class FileDownloaderService
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def generate_name
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (0...29).map{ o[rand(o.length)] }.join
  end

  def zip_file(field_ids)
    path     = "#{Rails.root}/public/downloads"
    filename = "Inscreva_#{generate_name}.zip"
    zip_name = "#{path}/#{filename}"
    field_ids = field_ids.map(&:to_i)

    Zip::ZipFile.open(zip_name, Zip::ZipFile::CREATE) do |zipfile|
      @subscriptions.eager_load(field_fills: :field).where('field_fills.field_id in (?)',
        field_ids).each do |sub|
        field_ids.each do |field_id|
          fill = sub.field_fills.detect{ |fill| fill.field_id == field_id}
          zipfile.add "#{fill.field.name.parameterize}/#{sub.name.parameterize}-" +
              "#{sub.number}#{File.extname(fill.file_url)}",
              fill.file_url if fill && !fill.file_url.blank?
        end
      end
    end

    "/downloads/#{filename}"
  end
end
