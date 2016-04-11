ExUnit.start
Code.require_file("linq.exs", __DIR__)

defmodule LinqTest do
  use ExUnit.Case

  test "table name" do
    assert String.contains?(Entity.all, "from entities as")
  end

  test "filter" do
    assert String.contains?(Entity.some, "name <> \"bah\"")
  end
end

defmodule Entity do
    import Linq

    schema table_name: "entities" do
      field :name, :string
      field :age, :integer
    end

    def all do
      from fejk in Entity
    end

    def some do
      from entity in Entity,
        where: entity.age > 0 and entity.age < 30 and entity.name != "bah"
    end

    def map do
      from entity in Entity,
        select: [name: entity.name]
    end

    def map_some do
      from entity in Entity,
        where: entity.age == 40,
        select: [name: entity.name]
    end
  end
