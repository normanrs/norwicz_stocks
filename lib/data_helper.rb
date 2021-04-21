# frozen_string_literal: true

require 'csv'
require 'yaml'

module DataHelper
  def stock_list
    if env_config == 'dev'
      ['AAPL']
    else
      reits
    end
  end

  def reits
    @reits ||= CSV.read('data/reits.csv', 'r:bom|utf-8').flatten
  end

  def config
    yaml_file = YAML.safe_load(File.read('config.yml'), aliases: true)
    @config ||= yaml_file.dig(env_config)
  end

  def env_config
    @env_config ||= ENV['CONFIG'] || 'dev'
  end
end
