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

    Zip::ZipFile.open(zip_name, Zip::ZipFile::CREATE) do |zipfile|
      @subscriptions.each do |sub|
        field_ids.each do |field_id|
          sub.field_fills.where(field_id: field_id).includes(:field).each do |fill|
            zipfile.add "#{fill.field.name.parameterize}/#{sub.name.parameterize}-" +
                "#{sub.number}#{File.extname(fill.file_url)}",
                fill.file_url if !fill.file_url.blank?
          end
        end
      end
    end

    "/downloads/#{filename}"
  end
end
