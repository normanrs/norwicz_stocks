# frozen_string_literal: true

require './lib/write_financials.rb'
# WriteFinancials.pull_dir_from_s3('data')
WriteFinancials.push_dir_to_s3('data')
