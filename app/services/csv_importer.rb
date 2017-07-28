require 'csv'

class CsvImporter
  class << self
    def import_companies!
      data = read_company_csv
      companies = data.collect { |record| Company.new(record) }
      Company.import(companies)
    end

    def import_historical!
      company_id_map = build_company_id_mapping
      path = Rails.root.join('data', 'asx', 'prices').to_s
      files = Dir.glob(File.join(path, '**', '*.txt'))
      count = files.size
      files.each_with_index do |file, i|
        puts "Loading file #{i + 1} of #{count}: #{file}"
        data = read_historical_share_data([file], company_id_map)
        historical = data.collect { |record| Daily.new(record) }
        Daily.import(historical)
      end
    end

    def build_company_id_mapping
      Company.pluck(:id, :symbol).inject({}) { |a, e| a[e[1]] = e[0]; a  }
    end

    def read_company_csv
      companies = []
      filename = Rails.root.join('data', 'asx', 'securities', 'ASXListedCompanies.csv').to_s
      CSV.foreach(filename) do |row|
        companies.push(name: row[0], symbol: row[1], category_name: row[2])
      end
      companies
    end

    def read_historical_share_data(files, company_id_map)
      dataset = []
      files.each do |filename|
        CSV.foreach(filename) do |row|
          # 3DP,20170407,0.028,0.028,0.028,0.028,191270
          symbol, date, open, high, low, close, volume = row
          company_id = company_id_map[symbol]
          dataset.push(company_id: company_id, symbol: symbol, date: date, open: open, high: high, low: low,
                       close: close, volume: volume)
        end
      end
      dataset
    end
  end
end