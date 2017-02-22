module Bank

  class Account
    attr_accessor :balance, :owner
    attr_reader :id

    def initialize(id, balance)
      @id = id

      if balance >= 0
        @balance = balance
      else
        raise ArgumentError.new "You cannot initialize a new account with a negative balance."
      end

      def add_owner(owner)
        if owner.class == Owner
          @owner = owner
        else
          raise ArgumentError.new "You must add a class type of Owner."
        end
      end

      def withdraw(withdrawal_amount)
        if withdrawal_amount > 0
          if withdrawal_amount <= @balance
            @balance -= withdrawal_amount
          else
            puts "You are going negative."
            @balance
          end
        else
          raise ArgumentError.new "Your withdrawal amount must be positive."
        end
      end

      def deposit(deposit_amount)
        if deposit_amount > 0
          @balance += deposit_amount
        else
          raise ArgumentError.new "Your deposit must be greater than zero."
        end
      end

    end

  end

  class Owner
    attr_reader :name, :phone

    def initialize(name, phone)
      name = name
      phone = phone
    end

  end

end
