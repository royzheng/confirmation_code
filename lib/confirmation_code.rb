Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/confirmation_code/service/*.rb").sort.each do |f|
  require f.match(/(confirmation_code\/service\/.*)\.rb$/)[0]
end

require 'httpclient'

module ConfirmationCode
  extend self

  attr_reader :username, :password

  def use(service, username, password, options = {})
    @service = ConfirmationCode::Service.const_get("#{service.to_s.capitalize}")
    @service.set_extra_options(options)
    @username = username
    @password = password
    @service
  end

  def upload(image_path, options = {})
    options = default_options.merge options
    if image_path.start_with?('http')
      @service.upload image_path, options if @service
    else
      @service.upload_local image_path, options if @service
    end
  end

  def account
    @service.account default_options if @service
  end

  def recognition_error(yzm_id)
    @service.recognition_error yzm_id, default_options if @service
  end

  private

  def default_options
    {
        user_name:  @username,
        user_pw:  @password,
    }
  end

end