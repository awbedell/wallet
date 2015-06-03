class Mony < ActiveRecord::Base

  def self.negative_balance
    if Mony.sum(:amount) < 0
      "You have a negative account balance.  Have you considered eating rice and beans for a while?"
    end
  end

  def self.total
    "$#{Mony.sum(:amount)}"
  end

  def self.spent
    array = Mony.select{ |mon| mon.amount < 0 }
    array.map! {|item| item.amount}
    "$#{array.reduce(:+).abs}"
  end

  def self.spent_this_month
    array = Mony.select{|money| money.amount < 0}
    array = array.select{|money| Date.today.mon == money.date_of_transaction.mon}
    array.map!{|item| item.amount}
    "$#{array.reduce(:+).abs}"
  end

  def self.transactions_this_month
    array = Mony.select{|money| money.amount < 0}
    array = array.select{|money| Date.today.mon == money.date_of_transaction.mon}
    array.length
  end

  def self.spent_last_month
    array = Mony.select{|money| money.amount < 0}
    array = array.select{|money| (Date.today.mon - 1 == money.date_of_transaction.mon)}
    array.map!{|item| item.amount}
    "$#{array.reduce(:+).abs}"
  end

  def self.transactions_last_month
    array = Mony.select{|money| Date.today.mon - 1 == money.date_of_transaction.mon}
    array.length
  end

  def self.biggest_expense
    "$#{Mony.order(:amount).first.amount.abs}"
  end

  def self.biggest_expense_last_month
    array = Mony.select{|money| (Date.today.mon - 1 == money.date_of_transaction.mon)}
    array.sort_by{ |money| money.amount }
    "$#{array.last.amount.abs}"
  end

  def biggest_recipient
    biggest = Mony.order_by(:other_party)
  end
end