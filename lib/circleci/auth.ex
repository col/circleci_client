defprotocol CircleCI.Auth do
  @moduledoc """
  Protocol for extracting API authentication tokens from application structs

  Credentials can be passed to operations using the `auth` option as strings for tokens. Sometimes, it's more
  convenient to pass a struct — like as a user struct — and extract the auth token from that.

  By implementing this protocol, the client can extract an auth token from the given struct without
  additional work by the caller.

  ## Example

      defimpl CircleCI.Auth, for: MyApp.User do
        def to_auth(%MyApp.User{github_token: token}), do: token
      end
  """

  @typedoc "Auth token accepted by the client"
  @type auth ::
          nil
          | (token :: String.t())

  @doc """
  Extract an auth token from the given struct

  The returned data should be in the form of a string (for a Bearer token) or a 2-tuple (for a Basic
  Auth user/password pair).
  """
  @spec to_auth(t) :: auth
  def to_auth(value)
end
