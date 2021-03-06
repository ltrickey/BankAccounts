require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/account'

describe "Wave 1" do
  #writing my own test
  describe "Owner#initialize" do
    it "Takes Name and Phone # to initialize Owner" do
      last_name = "Trickey"
      first_name = "lynn"

      new_owner = Bank::Owner.new(last_name, first_name)

      new_owner.must_respond_to :last_name
      new_owner.must_respond_to :first_name
      end
  end

  describe "Account#initialize" do
    it "Takes an ID and an initial balance" do
      id = 1337
      balance = 100.0
      account = Bank::Account.new(id, balance)

      account.must_respond_to :id
      account.id.must_equal id

      account.must_respond_to :balance
      account.balance.must_equal balance
    end

    it "Raises an ArgumentError when created with a negative balance" do
      # Note: we haven't talked about procs yet. You can think
      # of them like blocks that sit by themselves.
      # This code checks that, when the proc is executed, it
      # raises an ArgumentError.
      proc {
        Bank::Account.new(1337, -100.0)
      }.must_raise ArgumentError
    end

    it "Can be created with a balance of 0" do
      # If this raises, the test will fail. No 'must's needed!
      Bank::Account.new(1337, 0, "opendate")
    end
  end

  describe "Account#add_owner" do
    before do
      @account = Bank::Account.new(1337, 10)
      @lynn = Bank::Owner.new("Lynn Trickey", "555-555-5555")
    end
    it "Adds an Owner instance and saves it as an instance variable" do
       @account.add_owner(@lynn)
       @account.owner.must_equal @lynn
    end

    it "Raises an Argument when add_owner is called and the owner argument is not class Owner" do
      #Should raise error
      proc { @account.add_owner("not class Owner") }.must_raise ArgumentError
    end
  end

  describe "Account#withdraw" do
    it "Reduces the balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance,)

      account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      updated_balance.must_equal expected_balance
    end

    it "Outputs a warning if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      # Another proc! This test expects something to be printed
      # to the terminal, using 'must_output'. /.+/ is a regular
      # expression matching one or more characters - as long as
      # anything at all is printed out the test will pass.
      proc {
        account.withdraw(withdrawal_amount)
      }.must_output(/.+/)
    end

    it "Doesn't modify the balance if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      # Both the value returned and the balance in the account
      # must be un-modified.
      updated_balance.must_equal start_balance
      account.balance.must_equal start_balance
    end

    it "Allows the balance to go to 0" do
      account = Bank::Account.new(1337, 100.0)
      updated_balance = account.withdraw(account.balance)
      updated_balance.must_equal 0
      account.balance.must_equal 0
    end

    it "Requires a positive withdrawal amount" do
      start_balance = 100.0
      withdrawal_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.withdraw(withdrawal_amount)
      }.must_raise ArgumentError
    end
  end

  describe "Account#deposit" do
    it "Increases the balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      updated_balance.must_equal expected_balance
    end

    it "Requires a positive deposit amount" do
      start_balance = 100.0
      deposit_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.deposit(deposit_amount)
      }.must_raise ArgumentError
    end
  end
end

#Wave 2
describe "Wave 2" do

  describe "Testing Owner class methods" do
    before do
      @all_owners = Bank::Owner.all
    end

    it "Returns an array of Owner instances" do
      @all_owners.must_be_instance_of(Array)
    end

    it "Verifies every item in array is an Owner" do
      @all_owners.each do |item|
        item.class.must_equal(Bank::Owner)
      end
    end

    it "Number of Owners match lines in CSV file" do
      csv_lines = CSV.read("support/owners.csv").length

      @all_owners.length.must_equal(csv_lines)
    end

    it "Name and address of first and last match CSV file" do
      first_names = []
      street_addresses = []
      CSV.open("support/owners.csv").each do |line|
        first_names << line[2]
        street_addresses << line[3]
      end

      #checks first and last first_names
      @all_owners[0].first_name.must_equal(first_names[0])
      @all_owners[-1].first_name.must_equal(first_names[-1])

      #checks first and last street_addresses
      @all_owners[0].first_name.must_equal(first_names[0])
      @all_owners[-1].first_name.must_equal(first_names[-1])

    end

  end

  describe "Testing Owner.find" do

    it "Returns an account that exists" do
      owner = Bank::Owner.find(14)
      owner.must_be_instance_of(Bank::Owner)
    end

    it "Can find the first account from the CSV" do
      Bank::Owner.find(14)
    end

    it "Can find the last account from the CSV" do
      Bank::Owner.find(25)
    end

    it "Raises an error for an Owner that doesn't exist" do
    #should raise an error when I try to find this
      proc { Bank::Owner.find(0000000) }.must_raise ArgumentError
    end

  end

  describe "Account.all" do

    before do
      @new_bank = Bank::Account.all
    end

    it "Returns an array of all accounts" do
      @new_bank.class.must_equal(Array)
    end

    it "Verifies every item in array is an Account" do
      @new_bank.each do |item|
        item.class.must_equal(Bank::Account)
      end
    end

    it "The number of accounts matches lines in CSV file, so number of accounts is correct" do

      csv_lines = CSV.read("support/accounts.csv").length

      @new_bank.length.must_equal(csv_lines)
    end

    it "ID and balance of first & last account matches ID and balance in CSV" do
      ids = []
      balances = []
      CSV.open("support/accounts.csv").each do |line|
        ids << line[0].to_i
        balances << line[1].to_i
      end

      #checks first and last ids
      @new_bank[0].id.must_equal(ids[0])
      @new_bank[-1].id.must_equal(ids[-1])

      #checks first and last balances
      @new_bank[0].balance.must_equal(balances[0])
      @new_bank[-1].balance.must_equal(balances[-1])
    end

  end

  describe "Account.find" do
    it "Returns an account that exists" do
      account = Bank::Account.find(15151)
      account.must_be_instance_of(Bank::Account)
    end

    it "Can find the first account from the CSV" do
      Bank::Account.find(1212)
    end

    it "Can find the last account from the CSV" do
      Bank::Account.find(15156)
    end

    it "Raises an error for an account that doesn't exist" do
    #should raise an error when I try to find this
    proc {
      Bank::Account.find(0000000)
    }.must_raise ArgumentError
    end

  end

end
