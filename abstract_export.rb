require 'intercom'
require 'csv'

class AbstractExport
  def initialize(criteria)
    @criteria = criteria
    @data = []
  end

  def call
    fetch_results
    export
  end

  def self.call(criteria)
    new(criteria).call
  end

  private

  attr_reader :data, :criteria

  def intercom
    @_intercom ||= Intercom::Client.new(token: ENV['INTERCOM_TOKEN'])
  end

  def fetch_results
    raise NotImplementedError
  end

  def export
    CSV.open(filename, "wb") do |csv|
      csv << headers

      data.flatten.each do |datum|
        csv << format_datum(datum)
      end
    end
  end

  def filename
    "exports/#{filename_prefix}-#{Time.now.to_i}.csv"
  end

  def filename_prefix
    raise NotImplementedError
  end

  def headers
    raise NotImplementedError
  end

  def format_datum(datum)
    raise NotImplementedError
  end
end
