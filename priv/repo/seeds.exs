alias Stonks.Repo
alias Stonks.Accounts.Operator

operator_id = "b75b1571-072e-4cf3-a984-28dc1dde13ae"
Repo.insert(%Operator{id: operator_id, email: "operator@stonks.co", password_hash: "hash"}, on_conflict: :nothing)
