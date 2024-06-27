defmodule CircleCI.Job do
  @moduledoc """
  Provides API endpoint related to job
  """

  @default_client CircleCI.Client

  @type get_job_details_200_json_resp :: %{
          contexts: [CircleCI.JobContexts.get_job_details_200_json_resp()],
          created_at: DateTime.t(),
          duration: integer,
          executor: CircleCI.JobExecutor.get_job_details_200_json_resp(),
          latest_workflow: CircleCI.JobLatestWorkflow.get_job_details_200_json_resp(),
          messages: [CircleCI.JobMessages.get_job_details_200_json_resp()],
          name: String.t(),
          number: integer,
          organization: CircleCI.JobOrganization.get_job_details_200_json_resp(),
          parallel_runs: [CircleCI.JobParallelRuns.get_job_details_200_json_resp()],
          parallelism: integer,
          pipeline: CircleCI.JobPipeline.get_job_details_200_json_resp(),
          project: CircleCI.JobProject.get_job_details_200_json_resp(),
          queued_at: DateTime.t(),
          started_at: DateTime.t() | nil,
          status: String.t(),
          stopped_at: DateTime.t() | nil,
          web_url: String.t()
        }

  @type get_job_details_default_json_resp :: %{message: String.t() | nil}

  @doc """
  Get job details

  Returns job details.
  """
  @spec get_job_details(map, String.t(), keyword) :: {:ok, map} | {:error, map}
  def get_job_details(job_number, project_slug, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [job_number: job_number, project_slug: project_slug],
      call: {CircleCI.Job, :get_job_details},
      url: "/project/#{project_slug}/job/#{job_number}",
      method: :get,
      response: [
        {200, {CircleCI.Job, :get_job_details_200_json_resp}},
        default: {CircleCI.Job, :get_job_details_default_json_resp}
      ],
      opts: opts
    })
  end

  @type t :: %__MODULE__{
          approval_request_id: String.t() | nil,
          approved_by: String.t() | nil,
          canceled_by: String.t() | nil,
          dependencies: [String.t()],
          id: String.t(),
          job_number: integer | nil,
          name: String.t(),
          project_slug: String.t(),
          started_at: DateTime.t() | nil,
          status: String.t(),
          stopped_at: DateTime.t() | nil,
          type: String.t()
        }

  defstruct [
    :approval_request_id,
    :approved_by,
    :canceled_by,
    :dependencies,
    :id,
    :job_number,
    :name,
    :project_slug,
    :started_at,
    :status,
    :stopped_at,
    :type
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:get_job_details_200_json_resp) do
    [
      contexts: [{CircleCI.JobContexts, :get_job_details_200_json_resp}],
      created_at: {:string, :date_time},
      duration: :integer,
      executor: {CircleCI.JobExecutor, :get_job_details_200_json_resp},
      latest_workflow: {CircleCI.JobLatestWorkflow, :get_job_details_200_json_resp},
      messages: [{CircleCI.JobMessages, :get_job_details_200_json_resp}],
      name: {:string, :generic},
      number: :integer,
      organization: {CircleCI.JobOrganization, :get_job_details_200_json_resp},
      parallel_runs: [{CircleCI.JobParallelRuns, :get_job_details_200_json_resp}],
      parallelism: :integer,
      pipeline: {CircleCI.JobPipeline, :get_job_details_200_json_resp},
      project: {CircleCI.JobProject, :get_job_details_200_json_resp},
      queued_at: {:string, :date_time},
      started_at: {:string, :date_time},
      status:
        {:enum,
         [
           "success",
           "running",
           "not_run",
           "failed",
           "retried",
           "queued",
           "not_running",
           "infrastructure_fail",
           "timedout",
           "on_hold",
           "terminated-unknown",
           "blocked",
           "canceled",
           "unauthorized"
         ]},
      stopped_at: {:string, :date_time},
      web_url: {:string, :generic}
    ]
  end

  def __fields__(:get_job_details_default_json_resp) do
    [message: {:string, :generic}]
  end

  def __fields__(:t) do
    [
      approval_request_id: {:string, :uuid},
      approved_by: {:string, :uuid},
      canceled_by: {:string, :uuid},
      dependencies: [string: :uuid],
      id: {:string, :uuid},
      job_number: :integer,
      name: {:string, :generic},
      project_slug: {:string, :generic},
      started_at: {:string, :date_time},
      status:
        {:enum,
         [
           "success",
           "running",
           "not_run",
           "failed",
           "retried",
           "queued",
           "not_running",
           "infrastructure_fail",
           "timedout",
           "on_hold",
           "terminated-unknown",
           "blocked",
           "canceled",
           "unauthorized"
         ]},
      stopped_at: {:string, :date_time},
      type: {:enum, ["build", "approval"]}
    ]
  end
end
