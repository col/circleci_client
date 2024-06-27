defmodule CircleCI.Pipeline do
  @moduledoc """
  Provides API endpoints related to pipeline
  """

  @default_client CircleCI.Client

  @type get_pipeline_by_id_default_json_resp :: %{message: String.t() | nil}

  @doc """
  Get a pipeline by ID

  Returns a pipeline by the pipeline ID.
  """
  @spec get_pipeline_by_id(String.t(), keyword) :: {:ok, CircleCI.Pipeline.t()} | {:error, map}
  def get_pipeline_by_id(pipeline_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [pipeline_id: pipeline_id],
      call: {CircleCI.Pipeline, :get_pipeline_by_id},
      url: "/pipeline/#{pipeline_id}",
      method: :get,
      response: [
        {200, {CircleCI.Pipeline, :t}},
        default: {CircleCI.Pipeline, :get_pipeline_by_id_default_json_resp}
      ],
      opts: opts
    })
  end

  @type get_pipeline_by_number_default_json_resp :: %{message: String.t() | nil}

  @doc """
  Get a pipeline by pipeline number

  Returns a pipeline by the pipeline number.
  """
  @spec get_pipeline_by_number(String.t(), map, keyword) ::
          {:ok, CircleCI.Pipeline.t()} | {:error, map}
  def get_pipeline_by_number(project_slug, pipeline_number, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [project_slug: project_slug, pipeline_number: pipeline_number],
      call: {CircleCI.Pipeline, :get_pipeline_by_number},
      url: "/project/#{project_slug}/pipeline/#{pipeline_number}",
      method: :get,
      response: [
        {200, {CircleCI.Pipeline, :t}},
        default: {CircleCI.Pipeline, :get_pipeline_by_number_default_json_resp}
      ],
      opts: opts
    })
  end

  @type t :: %__MODULE__{
          created_at: DateTime.t(),
          errors: [CircleCI.PipelineErrors.t()],
          id: String.t(),
          number: integer,
          project_slug: String.t(),
          state: String.t(),
          trigger: CircleCI.PipelineTrigger.t(),
          trigger_parameters: CircleCI.PipelineTriggerParameters.t() | nil,
          updated_at: DateTime.t() | nil,
          vcs: CircleCI.PipelineVcs.t() | nil
        }

  defstruct [
    :created_at,
    :errors,
    :id,
    :number,
    :project_slug,
    :state,
    :trigger,
    :trigger_parameters,
    :updated_at,
    :vcs
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:get_pipeline_by_id_default_json_resp) do
    [message: {:string, :generic}]
  end

  def __fields__(:get_pipeline_by_number_default_json_resp) do
    [message: {:string, :generic}]
  end

  def __fields__(:t) do
    [
      created_at: {:string, :date_time},
      errors: [{CircleCI.PipelineErrors, :t}],
      id: {:string, :uuid},
      number: :integer,
      project_slug: {:string, :generic},
      state: {:enum, ["created", "errored", "setup-pending", "setup", "pending"]},
      trigger: {CircleCI.PipelineTrigger, :t},
      trigger_parameters: {CircleCI.PipelineTriggerParameters, :t},
      updated_at: {:string, :date_time},
      vcs: {CircleCI.PipelineVcs, :t}
    ]
  end
end
