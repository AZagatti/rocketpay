defmodule Rocketpay.Accounts.WithdrawTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Account, User}
  alias Rocketpay.Accounts.{Deposit, Withdraw}

  describe "call/1" do
    setup do
      params = %{
        name: "Andre",
        password: "123456",
        nickname: "Zagatti",
        email: "andre@teste.com",
        age: 23
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      {:ok, account_id: account_id}
    end

    test "when a valid value and id, make the withdraw", %{account_id: account_id} do
      value = Decimal.new("50.00")

      Deposit.call(%{"id" => account_id, "value" => value})
      result = Withdraw.call(%{"id" => account_id, "value" => value})

      assert {:ok, %Account{id: ^account_id, balance: balance}} = result
      assert balance == Decimal.new("0.00")
    end
  end
end
