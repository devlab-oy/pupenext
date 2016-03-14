module TranportsHelper
  def transport_encoding_options
    Encoding.list.map(&:to_s).sort
  end
end
