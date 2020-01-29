module HotelPrice::Rakuten
  class RakutenConsole
    def initialize params
      @config = {
          login_id: params[:login_id],
          login_pw: params[:login_pw],
          chain: params[:chain] ||= false,
          rakuten_hotel_id: params[:rakuten_hotel_id] ||= 0,
      }
    end
  end
end