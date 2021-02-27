defmodule Rocketpay.Accounts.TransactionTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Account, User}
  alias Rocketpay.Accounts.{Deposit, Transaction}

  describe "call/1" do
    setup do
      from = %{
        name: "Andre",
        password: "123456",
        nickname: "Zagatti",
        email: "andre@teste.com",
        age: 23
      }

      to = %{
        name: "Andre",
        password: "123456",
        nickname: "Zagatti2",
        email: "andre2@teste.com",
        age: 23
      }

      {:ok, %User{account: %Account{id: to_id}}} = Rocketpay.create_user(from)
      {:ok, %User{account: %Account{id: from_id}}} = Rocketpay.create_user(to)

      {:ok, to_id: to_id, from_id: from_id}
    end

    test "when to_id have value to transfer to from_id, make transaction", %{
      from_id: from_id,
      to_id: to_id
    } do
      zero = Decimal.new("0.00")
      value = Decimal.new("50.00")
      Deposit.call(%{"id" => from_id, "value" => value})
      result = Transaction.call(%{"from" => from_id, "to" => to_id, "value" => value})

      assert {:ok,
              %{
                from_account: %Account{id: ^from_id, balance: from_balance},
                to_account: %Account{id: ^to_id, balance: to_balance}
              }} = result

      assert to_balance == value
      assert from_balance == zero
    end
  end
end
