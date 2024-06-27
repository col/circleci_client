defmodule CircleCI.PipelineVcs do
  @moduledoc """
  Provides struct and type for a PipelineVcs
  """

  @type t :: %__MODULE__{
          branch: String.t() | nil,
          commit: CircleCI.PipelineVcsCommit.t() | nil,
          origin_repository_url: String.t(),
          provider_name: String.t(),
          review_id: String.t() | nil,
          review_url: String.t() | nil,
          revision: String.t(),
          tag: String.t() | nil,
          target_repository_url: String.t()
        }

  defstruct [
    :branch,
    :commit,
    :origin_repository_url,
    :provider_name,
    :review_id,
    :review_url,
    :revision,
    :tag,
    :target_repository_url
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      branch: {:string, :generic},
      commit: {CircleCI.PipelineVcsCommit, :t},
      origin_repository_url: {:string, :generic},
      provider_name: {:string, :generic},
      review_id: {:string, :generic},
      review_url: {:string, :generic},
      revision: {:string, :generic},
      tag: {:string, :generic},
      target_repository_url: {:string, :generic}
    ]
  end
end
