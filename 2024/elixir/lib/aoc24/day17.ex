defmodule Aoc24.Day17 do
  import Aoc24.Parse
  import Bitwise

  @spec part1(String.t()) :: String.t()
  def part1(input) do
    {regs, program} = parse(input)

    regs
    |> run(0, program, [])
    |> Enum.join(",")
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp run(regs, ip, program, output) do
    if ip < length(program) do
      [op, opr] = Enum.slice(program, ip, 2)

      case execute(op, opr, regs) do
        {_a, _b, _c} = regs -> run(regs, ip + 2, program, output)
        {:out, value} -> run(regs, ip + 2, program, [value | output])
        {:jmp, i} -> run(regs, i, program, output)
      end
    else
      Enum.reverse(output)
    end
  end

  def execute(0 = _adv, opr, {a, b, c} = regs), do: {div(a, 2 ** cbo(opr, regs)), b, c}
  def execute(1 = _bxl, opr, {a, b, c}), do: {a, bxor(b, opr), c}
  def execute(2 = _bst, opr, {a, _, c} = regs), do: {a, cbo(opr, regs) &&& 7, c}
  def execute(3 = _jnz, _, {0, _, _} = regs), do: regs
  def execute(3 = _jnz, opr, _), do: {:jmp, opr}
  def execute(4 = _bxc, _, {a, b, c}), do: {a, bxor(b, c), c}
  def execute(5 = _out, opr, regs), do: {:out, cbo(opr, regs) &&& 7}
  def execute(6 = _bdv, opr, {a, _, c} = regs), do: {a, div(a, 2 ** cbo(opr, regs)), c}
  def execute(7 = _cdv, opr, {a, b, _} = regs), do: {a, b, div(a, 2 ** cbo(opr, regs))}

  defp cbo(n, _regs) when n in 0..3, do: n
  defp cbo(4, {a, _, _}), do: a
  defp cbo(5, {_, b, _}), do: b
  defp cbo(6, {_, _, c}), do: c

  defp parse(input) do
    {regs, input} = parse_registers(input)
    program = parse_program(input)
    {regs, program}
  end

  defp parse_registers(input) do
    {a, input} = input |> drop("Register A: ") |> int()
    {b, input} = input |> drop("\nRegister B: ") |> int()
    {c, input} = input |> drop("\nRegister C: ") |> int()
    {{a, b, c}, input |> drop("\n\n")}
  end

  defp parse_program(input) do
    input
    |> drop("Program: ")
    |> String.trim()
    |> ints(",")
  end
end
