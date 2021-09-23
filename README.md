# MrNatural

A utility to compare strings in [natural sort order](https://en.wikipedia.org/wiki/Natural_sort_order).

Natural sort order is useful for humans. By default sorting Strings is a lot differently

## Installation

```elixir
def deps do
  [
    {:mr_natural, "~> 0.1.0"}
  ]
end
```

# Usage

To compare two strings directly.

```elixir
  iex> MrNatural.compare("String2", "String11")
  :lt

  iex>  MrNatural.compare("String11", "String2")
  :gt
```

Using `Enum.sort/2`

```elixir
   iex> Enum.sort(["String2", "String11", "String3"], MrNatural)
   ["String2", "String3",  "String11"]

   iex> Enum.sort(["String2", "String11", "String3"], {:asc, MrNatural})
   ["String2", "String3",  "String11"]

   iex> Enum.sort(["String2", "String11", "String3"], {:desc, MrNatural})
   ["String11", "String3",  "String2"]
```


The docs can be found at [https://hexdocs.pm/mr_natural](https://hexdocs.pm/mr_natural).

