module ParamsHelper

  def shorten_params(value)
    raise ArgumentError unless value.is_a? Hash

    v = value.to_query
    z = Zlib::Deflate.deflate v, 9
    Base64.urlsafe_encode64 z
  end

  def unshorten_params(value)
    raise ArgumentError unless value.is_a? String

    v = Base64.urlsafe_decode64 value
    z = Zlib::Inflate.inflate v
    Rack::Utils.parse_nested_query(z).symbolize_keys
  end

end
