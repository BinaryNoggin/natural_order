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
      :gt

      iex> NaturalOrder.compare("string", "string")
      :eq

  # Examples with sorting

      iex> Enum.sort(["String2", "String11", "String3"], NaturalOrder)
      ["String2", "String3",  "String11"]

      iex> Enum.sort(["String2", "String11", "String3"], {:asc, NaturalOrder})
      ["String2", "String3",  "String11"]

      iex> Enum.sort(["String2", "String11", "String3"], {:desc, NaturalOrder})
      ["String11", "String3",  "String2"]
  """

  @doc """
  Compares two strings in natural sort order.

  ## Examples

      iex> NaturalOrder.compare("String2", "String11")
      :lt

      iex> NaturalOrder.compare("String11", "String2")
      :gt

      iex> NaturalOrder.compare("string", "STRING")
      :gt

      iex> NaturalOrder.compare("string", "string")
      :eq

  """
  @spec compare(String.t(), String.t()) :: :lt | :eq | :gt
  def compare(string1, string2) when is_binary(string1) and is_binary(string2) do
    compare_formatted(format(string1), format(string2))
  end

  defp compare_formatted([], []),
    do: :eq

  defp compare_formatted([], [_head2 | _tail2]),
    do: :lt

  defp compare_formatted([_head1 | _tail1], []),
    do: :gt

  defp compare_formatted([head1 | tail1], [head2 | tail2])
       when is_tuple(head1) and is_tuple(head2) do
    case compare_formatted_tuple(head1, head2) do
      :eq -> compare_formatted(tail1, tail2)
      other -> other
    end
  end

  defp compare_formatted_tuple(tuple1, tuple1),
    do: :eq

  defp compare_formatted_tuple(tuple1, tuple2) when tuple1 <= tuple2,
    do: :lt

  defp compare_formatted_tuple(_tuple1, _tuple2),
    do: :gt

  defp format(string) do
    string
    |> split()
    |> normalize()
  end

  defp split(string) do
    Regex.split(~r/([0-9]+)|(\p{L}+)/u, string, include_captures: true, trim: true)
  end

  defp normalize(list) when is_list(list) do
    Enum.map(list, &normalize_string/1)
  end

  defp normalize_string(string) do
    normalized = to_integer(string)

    {downcase(normalized), normalized, string}
  end

  defp to_integer(<<char, _rest::binary>> = string) when char in ?0..?9,
    do: String.to_integer(string)

  defp to_integer(string),
    do: string

  defp downcase(string) when is_binary(string),
    do: String.downcase(string)

  defp downcase(string),
    do: string
end
