# frozen_string_literal: true

require 'aws-sdk-s3'
require 'csv'
require 'json'

module WriteHelper
  def write_json(filename, hash_in)
    puts "Writing #{filename}"
    File.open(filename, 'w') do |f|
      f.write(JSON.pretty_generate(hash_in, indent: "\t", object_nl: "\n"))
    end
  end

  def write_csv(hash_in)
    headers = hash_in.values.first.keys.unshift('TICKER')
    CSV.open('data/stock_data.csv', 'wb', write_headers: true, headers: headers) do |csv|
      hash_in.each do |key, data|
        csv << data.values.unshift(key)
      end
    end
  end

  def push_to_s3(dir)
    Dir.glob("#{dir}/*.*").each do |path_filename|
      puts "Writing #{path_filename} to S3 bucket"
      s3 = Aws::S3::Resource.new(region: 'us-east-1')
      obj = s3.bucket(BUCKET).object(path_filename.to_s)
      obj.upload_file(path_filename.to_s)
    end
  end
end
