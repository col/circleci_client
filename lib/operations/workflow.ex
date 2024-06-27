defmodule CircleCI.Workflow do
  @moduledoc """
  Provides API endpoints related to workflow
  """

  @default_client CircleCI.Client

  @type get_workflow_by_id_default_json_resp :: %{message: String.t() | nil}

  @doc """
  Get a workflow

  Returns summary fields of a workflow by ID.
  """
  @spec get_workflow_by_id(String.t(), keyword) :: {:ok, map} | {:error, map}
  def get_workflow_by_id(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call: {CircleCI.Workflow, :get_workflow_by_id},
      url: "/workflow/#{id}",
      method: :get,
      response: [
        {200, {CircleCI.Workflow, :t}},
        default: {CircleCI.Workflow, :get_workflow_by_id_default_json_resp}
      ],
      opts: opts
    })
  end

  @type list_workflow_jobs_200_json_resp :: %{
          items: [CircleCI.Job.t()],
          next_page_token: String.t() | nil
        }

  @type list_workflow_jobs_default_json_resp :: %{message: String.t() | nil}

  @doc """
  Get a workflow's jobs

  Returns a sequence of jobs for a workflow.
  """
  @spec list_workflow_jobs(String.t(), keyword) :: {:ok, map} | {:error, map}
  def list_workflow_jobs(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call: {CircleCI.Workflow, :list_workflow_jobs},
      url: "/workflow/#{id}/job",
      method: :get,
      response: [
        {200, {CircleCI.Workflow, :list_workflow_jobs_200_json_resp}},
        default: {CircleCI.Workflow, :list_workflow_jobs_default_json_resp}
      ],
      opts: opts
    })
  end

  @type t :: %__MODULE__{
          canceled_by: String.t() | nil,
          created_at: DateTime.t(),
          errored_by: String.t() | nil,
          id: String.t(),
          name: String.t(),
          pipeline_id: String.t(),
          pipeline_number: integer,
          project_slug: String.t(),
          started_by: String.t(),
          status: String.t(),
          stopped_at: DateTime.t() | nil,
          tag: String.t() | nil
        }

  defstruct [
    :canceled_by,
    :created_at,
    :errored_by,
    :id,
    :name,
    :pipeline_id,
    :pipeline_number,
    :project_slug,
    :started_by,
    :status,
    :stopped_at,
    :tag
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:get_workflow_by_id_default_json_resp) do
    [message: {:string, :generic}]
  end

  def __fields__(:list_workflow_jobs_200_json_resp) do
    [items: [{CircleCI.Job, :t}], next_page_token: {:string, :generic}]
  end

  def __fields__(:list_workflow_jobs_default_json_resp) do
    [message: {:string, :generic}]
  end

  def __fields__(:t) do
    [
      canceled_by: {:string, :uuid},
      created_at: {:string, :date_time},
      errored_by: {:string, :uuid},
      id: {:string, :uuid},
      name: {:string, :generic},
      pipeline_id: {:string, :uuid},
      pipeline_number: :integer,
      project_slug: {:string, :generic},
      started_by: {:string, :uuid},
      status:
        {:enum,
         [
           "success",
           "running",
           "not_run",
           "failed",
           "error",
           "failing",
           "on_hold",
           "canceled",
           "unauthorized"
         ]},
      stopped_at: {:string, :date_time},
      tag: {:string, :generic}
    ]
  end
end
