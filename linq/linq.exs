defmodule Linq do
  defmacro from({:in, _context, [{what, _, nil}, {:__aliases__, aliases, [from_where]}]} = ast, opts \\ []) do
    # IO.inspect ast
    # IO.inspect opts
    table_name = from_where
    table_alias = to_string(what)
    where_clause = Keyword.get(opts, :where) |> get_where_clauses(table_alias)
    if byte_size(where_clause) > 0 do
      where_clause = " where " <> where_clause
    end
    IO.puts "select"
    IO.inspect Keyword.get(opts, :select)
    select_clause = Keyword.get(opts, :select) |> get_select_clause(table_alias)
    quote do
      "select #{unquote(select_clause)} from #{unquote(table_name)} as #{unquote(table_alias)}#{unquote(where_clause)}"
    end
  end

  defmacro schema(options, do: block) do
    table_name = options[:table_name]
    IO.inspect block

    struct_def = get_struct_def(block)
    quote do
      @table_name unquote(table_name) || to_string(__MODULE__)
      IO.puts(@table_name)

      defstruct unquote(struct_def)
    end
  end

  def get_struct_def({:__block__, _, ast}) do
    for line <- ast, {:field, _field_line, [field_name, field_type | opts]} = line, into: [] do
      {field_name, nil}
    end
  end

  def get_where_clauses(nil, _), do: ""
  def get_where_clauses({{:., _, [lhs, rhs]}, _, []}, table_alias) do
    lhs = get_where_clauses(lhs, table_alias)
    rhs = get_where_clauses(rhs, table_alias)
    "#{lhs}.#{rhs}"
  end
  def get_where_clauses({atom, _, nil}, table_alias) do
    table_alias
  end
  def get_where_clauses(string, _) when is_bitstring(string) do
    "\"#{string}\""
  end
  def get_where_clauses(value, _) when is_number(value) or is_boolean(value) or is_atom(value) do
    to_string(value)
  end
  def get_where_clauses({op, _, [lhs, rhs]}, table_alias) do
    lhs = get_where_clauses(lhs, table_alias)
    rhs = get_where_clauses(rhs, table_alias)
    "#{lhs} #{translate_op(op)} #{rhs}"
  end
  def translate_op(:!=) do
    "<>"
  end
  def translate_op(op) do
    "#{to_string(op)}"
  end

  def get_select_clause(nil, table_alias), do: "#{table_alias}.*"
  def get_select_clause(fields, table_alias) do
    for item <- fields,
      {dest, src} = item,
      {{:., _, [_, field_name]}, _, _} = src,
      into: [] do
      # IO.inspect src
      "#{table_alias}.#{field_name}"
    end
  end
end

defmodule Fejk do
  import Linq

  schema table_name: "fakes" do
    field :name, :string
    field :age, :integer
  end

  def all do
    from fejk in Fejk
  end

  def some do
    from fejk in Fejk,
      where: fejk.age > 0 and fejk.age < 30 and fejk.name != "bah"
  end

  def map do
    from fejk in Fejk,
      select: [name: fejk.name]
  end

  def map_some do
    from fejk in Fejk,
      where: fejk.age == 40,
      select: [name: fejk.name]
  end
end
