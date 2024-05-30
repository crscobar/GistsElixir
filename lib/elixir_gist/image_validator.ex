defmodule ElixirGist.ImageValidator do
  def validate_image(data_url, allowed_file_size, allowed_file_types)
      when is_binary(data_url) and is_integer(allowed_file_size) and is_list(allowed_file_types) do
    # Extract the media type and the base64 part from the data_url
    IO.puts("Validating IMAGE")
    [meta_data, base64] = String.split(data_url, ",")

    [media_type, _] = String.replace(meta_data, "data:", "") |> String.split(";")

    # Decode the base64 part and get the binary data
    binary_data = Base.decode64!(base64)

    # Get the file size in bytes
    file_size = byte_size(binary_data)

    # Get the file extension from the media type
    file_ext = String.split(media_type, "/") |> Enum.at(1)

    # Check if the file extension is allowed
    case Enum.member?(allowed_file_types, file_ext) do
      true ->
        IO.puts("Validating IMAGE TRUE")
        # Check if the file size is less than or equal to 2MB
        case file_size <= allowed_file_size do
          true ->
            {:ok, data_url}

          false ->
            # Return an error message for invalid file size
            {:error, "Image size must be less than or equal to #{allowed_file_size}"}
        end

      false ->
        IO.puts("Validating IMAGE FALSE")
        # Return an error message for invalid file extension
        {:error, "Image file type must be jpg, jpeg, png, or gif"}
    end
  end
end
