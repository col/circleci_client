defmodule CircleCI.PipelineVcsCommit do
  @moduledoc """
  Provides struct and type for a PipelineVcsCommit
  """

  @type t :: %__MODULE__{body: String.t(), subject: String.t()}

  defstruct [:body, :subject]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [body: {:string, :generic}, subject: {:string, :generic}]
  end
end
