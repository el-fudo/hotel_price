module Jalan
  class JalanAPI
    def initialize api_key
      @api_key = api_key
    end

    def test
      @api_key
    end
  end
end