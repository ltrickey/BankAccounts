module Bank

  class SavingsAccount < Account

    def initialize(id, balance, opendate = "nodate")
      super
      if balance < 10
        raise ArgumentError.new "You must initially deposit at least $10.00"
      end
    end

    def withdraw(withdrawal_amount)
      super
      @balance -= 2
    end

  end

end
