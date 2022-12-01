{:ok, modules} = :application.get_key(:advent, :modules)

for module <- modules do
  defmodule :"#{module}Test" do
    use ExUnit.Case, async: true
    doctest module, import: true
  end
end
