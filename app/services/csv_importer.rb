require 'csv'

class CsvImporter
  class << self
    def import_companies!
      data = read_company_csv
      companies = data.collect { |record| Company.new(record) }
      Company.import(companies)
    end

    def import_historical!
      data = read_historical_share_data
      historical = data.collect { |record| Daily.new(record) }
      Daily.import(historical)
    end

    def read_company_csv
      companies = []
      filename = '/Users/wtfiwtz/Desktop/_Large/Downloads/shares/ASXListedCompanies.csv'
      CSV.foreach(filename) do |row|
        companies.push(name: row[0], symbol: row[1], category_name: row[2])
      end
      companies
    end

    def read_historical_share_data
      dataset = []
      path = '/Users/wtfiwtz/Desktop/_Large/Downloads/shares/week20170407'
      files = Dir.glob(File.join(path, '*.txt'))
      files.each do |filename|
        CSV.foreach(filename) do |row|
          # 3DP,20170407,0.028,0.028,0.028,0.028,191270
          symbol, date, open, high, low, close, volume = row
          dataset.push(symbol: symbol, date: date, open: open, high: high, low: low, close: close, volume: volume)
        end
      end
      dataset
    end
  end
end