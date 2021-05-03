# frozen_string_literal: true

require './lib/write_financials.rb'
WriteFinancials.write_statements
WriteFinancials.top_picks
WriteFinancials.push_dir_to_s3('data')
