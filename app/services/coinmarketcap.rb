require 'net/http'
require 'uri'

require_relative './coinmarketcap_results'

class Coinmarketcap
  class << self
    def load!
      results = market_caps
      load_results(results)
      update_symbols
    end

    def market_caps
      uri = URI.parse('https://api.coinmarketcap.com/v1/ticker/')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      json_response = JSON.parse(response.body)
    end

    def print_results(r)
      r.each do |crypto|
        puts "#{crypto['name']} - ranked #{crypto['rank']}; 24h: #{crypto['percent_change_24h']}%"
      end
    end

    def load_results(r, date = Time.now.utc)
      bulk_set = r.collect do |row|
        Crypto.new(row.merge(date: date, crypto_currency: nil, sym: row['id'], volume_24h_usd: row['24h_volume_usd']).except('id', '24h_volume_usd'))
      end
      results = Crypto.import(bulk_set)
    end

    def update_symbols
      # Crypto.delete_all
      # load_results(CoinmarketcapResults.results1, 24.hours.ago)
      # load_results(CoinmarketcapResults.results2, 12.hours.ago)
      # load_results(CoinmarketcapResults.results3)
      crypto_details = Crypto.distinct.pluck(:sym, :name)
      crypto_details.each do |pair|
        sym = pair[0]
        name = pair[1]
        currency = CryptoCurrency.where(sym: sym).first_or_create!(name: name)
        Crypto.where(sym: sym).update_all(crypto_currency_id: currency.id)
      end
    end
  end
end