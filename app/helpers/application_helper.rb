module ApplicationHelper
    def display_money(amount)

    amount = amount.floor.to_s
    if amount.length >= 4 && amount.length < 7
      amount.insert(-4, ",")
    elsif amount.length >= 7 && amount.length < 10
      amount.insert(-7, ",")
      amount.insert(-4, ",")
    elsif amount.length >= 10 && amount.length < 13
      amount.insert(-10, ",")
      amount.insert(-7, ",")
      amount.insert(-4, ",")
    elsif amount.length >= 13 && amount.length < 16
      amount.insert(-13, ",")
      amount.insert(-10, ",")
      amount.insert(-7, ",")
      amount.insert(-4, ",")
    end
    amount = amount.insert(0, "$")
  end
end
