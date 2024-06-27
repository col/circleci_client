defmodule CircleCI.PipelineTrigger do
  @moduledoc """
  Provides struct and type for a PipelineTrigger
  """

  @type t :: %__MODULE__{
          actor: CircleCI.PipelineTriggerActor.t(),
          received_at: DateTime.t(),
          type: String.t()
        }

  defstruct [:actor, :received_at, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      actor: {CircleCI.PipelineTriggerActor, :t},
      received_at: {:string, :date_time},
      type: {:enum, ["schedule", "explicit", "api", "webhook"]}
    ]
  end
end
