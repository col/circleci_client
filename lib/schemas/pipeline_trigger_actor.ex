defmodule CircleCI.PipelineTriggerActor do
  @moduledoc """
  Provides struct and type for a PipelineTriggerActor
  """

  @type t :: %__MODULE__{avatar_url: String.t() | nil, login: String.t()}

  defstruct [:avatar_url, :login]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [avatar_url: {:string, :generic}, login: {:string, :generic}]
  end
end
