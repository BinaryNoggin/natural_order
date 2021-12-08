defmodule NaturalOrder do
  @moduledoc """
  A utility to compare strings in [natural sort order](https://en.wikipedia.org/wiki/Natural_sort_order).

  Natural sort order is useful for humans. By default sorting Strings is a lot differently.

  ## Examples of comparing two strings

      iex> NaturalOrder.compare("String2", "String11")
      :lt

      iex> NaturalOrder.compare("String11", "String2")
      :gt

      iex> NaturalOrder.compare("string", "STRING")
      :eq

  # Examples with sorting

      iex> Enum.sort(["String2", "String11", "String3"], NaturalOrder)
      ["String2", "String3",  "String11"]

      iex> Enum.sort(["String2", "String11", "String3"], {:asc, NaturalOrder})
      ["String2", "String3",  "String11"]

      iex> Enum.sort(["String2", "String11", "String3"], {:desc, NaturalOrder})
      ["String11", "String3",  "String2"]
  """

  @has_integers ~r/\p{Nd}+/u

  @doc """
  Compares two strings ignoring case and in natural sort order.

  ## Examples

      iex> NaturalOrder.compare("String2", "String11")
      :lt

      iex> NaturalOrder.compare("String11", "String2")
      :gt

      iex> NaturalOrder.compare("string", "STRING")
      :eq
  """
  @spec compare(String.t(), String.t()) :: :eq | :gt | :lt
  def compare(string1, string2) when is_binary(string1) and is_binary(string2) do
    compare_formatted(format(string1), format(string2))
  end

  defp compare_formatted(string1, string1),
    do: :eq

  defp compare_formatted(string1, string2) when string1 < string2,
    do: :lt

  defp compare_formatted(_string1, _string2),
    do: :gt

  defp convert_integers(string) do
    if Regex.match?(@has_integers, string) do
      String.to_integer(string)
    else
      string
    end
  end

  defp format(string) do
    string
    |> String.downcase()
    |> split_integers(~r/(\p{Nd}+)|(\p{L}+)/u)
    |> List.flatten()
    |> Enum.map(&convert_integers/1)
  end

  defp split_integers(string, regex),
    do: Regex.scan(regex, string, capture: :all_but_first)
end
