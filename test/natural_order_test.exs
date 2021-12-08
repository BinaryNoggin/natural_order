defmodule NaturalOrderTest do
  use ExUnit.Case, async: true
  use PropCheck
  doctest NaturalOrder

  property "natural sort" do
    forall {a, b} <- {numeric_string(), numeric_string()} do
      meets_standard_sort_properties(a, b)
      |> when_fail(
        IO.puts("""
            a: #{a}
            b: #{b}
            compare a -> b: #{NaturalOrder.compare(a, b)}
            compare b -> a: #{NaturalOrder.compare(b, a)}
        """)
      )
    end
  end

  property "same string except numbers" do
    forall {{a, ai}, {b, bi}} <- string_numbers() do
      meets_standard_sort_properties(a, b) &&
        case NaturalOrder.compare(a, b) do
          :eq -> ai == bi
          :lt -> ai < bi
          :gt -> ai > bi
        end
        |> when_fail(
          IO.puts("""
              a: #{a}
              b: #{b}
              compare a -> b: #{NaturalOrder.compare(a, b)}
              compare b -> a: #{NaturalOrder.compare(b, a)}
          """)
        )
        |> collect(a)
        |> collect(ai)
    end
  end

  test "shuffled lists must return the same ordered result" do
    assert Enum.sort(~W(a/8 A/8 b/8), {:asc, NaturalOrder}) ==
             Enum.sort(~W(b/8 A/8 a/8), {:asc, NaturalOrder})
  end

  test "inequalities" do
    assert NaturalOrder.compare("A+1", "A-2") != :eq
    assert NaturalOrder.compare("A+1", "a+1") != :eq
    assert NaturalOrder.compare("string", "STRING") != :eq
  end

  test "with diacritics" do
    assert Enum.sort(~W(a/8 A/8 b/8), {:asc, NaturalOrder}) ==
             Enum.sort(~W(b/8 A/8 a/8), {:asc, NaturalOrder})

    assert Enum.sort(~W(ź/2 z/3 z/2 å/8 a/8 áb/8), {:asc, NaturalOrder}) == [
             "a/8",
             "å/8",
             "áb/8",
             "z/2",
             "z/3",
             "ź/2"
           ]
  end

  def meets_standard_sort_properties(a, b) do
    NaturalOrder.compare(a, a) == :eq &&
      case NaturalOrder.compare(a, b) do
        :eq -> NaturalOrder.compare(b, a) == :eq
        :lt -> NaturalOrder.compare(b, a) == :gt
        :gt -> NaturalOrder.compare(b, a) == :lt
      end
  end

  def numeric_string do
    oneof([string(), string_with_number()])
  end

  def string_numbers do
    let {text, x1, x2} <- {string(), non_neg_integer(), non_neg_integer()} do
      {first, last} = String.split_at(text, x1)

      {
        {first <> to_string(x1) <> last, x1},
        {first <> to_string(x2) <> last, x2}
      }
    end
  end

  def string_with_number do
    let {text, number} <- {string(), integer()} do
      {first, last} = String.split_at(text, number)
      first <> to_string(number) <> last
    end
  end

  def printable_character do
    integer(33, 126)
  end

  def empty_string do
    exactly("")
  end

  def non_empty_string do
    let char_list <- non_empty(list(printable_character())) do
      to_string(char_list)
    end
  end

  def string do
    frequency([
      {1, empty_string()},
      {9, non_empty_string()}
    ])
  end
end
