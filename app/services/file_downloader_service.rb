require 'zip/zip'

class FileDownloaderService
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def generate_name
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (0...19).map{ o[rand(o.length)] }.join
  end

  def zip_file(field_ids)
    zip_name = "#{Rails.root}/tmp/Inscreva_#{generate_name}.zip"

    Zip::ZipFile.open(zip_name, Zip::ZipFile::CREATE) do |zipfile|
      @subscriptions.each do |sub|
        field_ids.each do |field_id|
          sub.field_fills.where(field_id: field_id).includes(:field).each do |fill|
            zipfile.add "#{fill.field.name.parameterize}/#{sub.name.parameterize}-" +
                "#{sub.number}#{File.extname(fill.file_url)}",
                fill.file_url unless fill.file_url.blank?
          end
        end
      end
    end

    zip_name
  end
end
