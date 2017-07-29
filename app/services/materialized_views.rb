class MaterializedViews
  class << self
    def materialize!(kind = :second, pick = 100)
      symbols = Daily.distinct.order(symbol: :asc).pluck(:symbol)
      puts 'Building 1st order data...'
      symbols.in_groups_of(100, false) do |batch|
        if %i[first second].include?(kind)
          results1 = batch.collect { |symbol| first_order(symbol) }
          results1 = persist_summary(results1)
        end
        if kind == :second
          puts 'Building 2nd order data...'
          results2 = batch.collect { |symbol| second_order(symbol, pick, results1) }
          _results2 = persist_chain(results2)
        end
        puts 'Saved!'
      end
    end

    def persist_summary(results1)
      summaries = results1.collect do |symbol|
        symbol.collect do |r|
          DailySummary.new(company_id: r[:company_id], symbol: r[:symbol], index: r[:index],
                           kind: :differential, date: r[:date_to], timeframe: 86_400,
                           curr_val: r[:curr_val], prev_val: r[:prev_val],
                           change_val: r[:change_val], change_pct: r[:change_pct])
        end
      end.flatten
      DailySummary.import(summaries)
      summaries
    end

    def persist_chain(results2)
      chains = results2.collect do |symbol|
        symbol.collect do |r|
          Chain.new(company: r[:company], symbol: r[:symbol], order: 2, start_at: r[:date_from], finish_at: r[:date_to], width: r[:days] * 86_400,
                    timeframe: 86_400, change_val: r[:change_val], change_pct: r[:change_pct])
        end
      end.flatten
      Chain.import(chains)
      chains
    end

    def first_order(symbol)
      results = Daily.includes(:company).where(symbol: symbol).order(date: :asc)
      company = results.first&.company
      puts "... #{symbol}"
      close_prices = results.pluck(:date, :close).collect { |ary| { company: company, symbol: symbol, date: ary[0], close: ary[1], close_float: ary[1].to_f } }
      date_changes = []
      close_prices.each_with_index do |hsh, i|
        next if i.zero?
        prev = close_prices[i - 1]
        date_changes.push(calc_change(hsh, prev, i))
      end
      date_changes
    end

    def second_order(symbol, pick = 100, results1 = nil)
      puts "... #{symbol}"
      date_changes = locate_date_changes_or_exec_first_order(symbol, results1)
      best_days = locate_best_days(date_changes, pick)
      locate_chains(date_changes, best_days)
    end

    private

    def locate_date_changes_or_exec_first_order(symbol, results1)
      found = results1&.select { |r2| r2[:symbol] == symbol }
      return found if found
      first_order(symbol)
    end

    def calc_change(curr, prev, i)
      calc = { company: curr[:company], symbol: curr[:symbol], date_from: prev[:date], date_to: curr[:date],
               days: (curr[:date] - prev[:date]).to_f / 86_400,
               change_val: curr[:close_float] - prev[:close_float],
               curr_val: curr[:close_float],
               prev_val: prev[:close_float],
               index: i - 1 }
      calc[:change_pct] = prev[:close_float].zero? ? 0 : (curr[:close_float] - prev[:close_float]) / prev[:close_float]
      calc
    end

    def create_chain(curr, prev)
      calc = { company: curr[:company], symbol: curr[:symbol], date_from: prev[:date] - prev[:timeframe], date_to: curr[:date],
               days: curr[:timeframe].to_f / 86_400,
               change_val: curr[:curr_val] - prev[:prev_val],
               curr_val: curr[:curr_val],
               prev_val: prev[:prev_val],
               index: prev[:index] }
      calc[:change_pct] = prev[:prev_val].zero? ? 0 : (curr[:curr_val] - prev[:prev_val]) / prev[:prev_val]

      # TODO: What about options, can be up and down depending on the type of option
      return nil unless calc[:change_val].positive?

      calc
    end

    def locate_best_days(date_changes, pick = 100)
      pcts = date_changes.collect { |x| x[:change_pct] }.sort[-pick..-1] || []
      date_changes.select { |x| pcts.include?(x[:change_pct]) }
    end

    def locate_chains(date_changes, best_days)
      chains = []
      best_days.each do |best_day|
        index = best_day[:index]
        prev_low = find_prev_low(date_changes, index)
        next_high = find_next_high(date_changes, index)
        chain = create_chain(next_high, prev_low)
        chains.push(chain) if chain
      end
      chains
    end

    def find_prev_low(date_changes, index)
      min_val = date_changes[index][:prev_val]
      (index - 1).downto(0).each do |i|
        if date_changes[i][:prev_val] < min_val
          min_val = date_changes[i][:prev_val]
        else
          return date_changes[i + 1]
        end
      end
      date_changes[0]
    end

    def find_next_high(date_changes, index)
      max_val = date_changes[index][:curr_val]
      (index + 1).upto(date_changes.size - 1).each do |i|
        if date_changes[i][:curr_val] > max_val
          max_val = date_changes[i][:curr_val]
        else
          return date_changes[i - 1]
        end
      end
      date_changes.last
    end
  end
end