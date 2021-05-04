defmodule RiakView.Riak do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://localhost:8098")

  def ping() do
    get("/ping/")
  end

  def all_buckets() do
    {:ok, %{body: body}} = get("/buckets?buckets=true")
    body |> Jason.decode!() |> Map.get("buckets")
  end

  def get_bucket_properties(bucket) do
    {:ok, %{body: body}} = get("/buckets/#{bucket}/props")
    body |> Jason.decode!() |> Map.get("props")
  end

  def all_keys(bucket) do
    {:ok, %{body: body}} = get("/buckets/#{bucket}/keys?keys=true")

    body
    |> Jason.decode!()
    |> Map.get("keys")
  end

  def get_key(bucket, key) do
    key = URI.encode_www_form(key)

    {:ok, %{body: body, headers: headers}} =
      get("/buckets/#{bucket}/keys/#{key}")

    headers = Map.new(headers)

    {:ok,
     %{
       value: :erlang.binary_to_term(body),
       updated: headers["last-modified"],
       etag: headers["etag"]
     }}
  end
end
