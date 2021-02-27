defmodule Rocketpay.Accounts.DepositTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Account, User}
  alias Rocketpay.Accounts.Deposit

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

    test "when a valid value and id, make the deposit", %{account_id: account_id} do
      value = Decimal.new("50.00")

      result = Deposit.call(%{"id" => account_id, "value" => value})

      assert {:ok, %Account{id: ^account_id, balance: balance}} = result
      assert balance == value
    end
  end
end
