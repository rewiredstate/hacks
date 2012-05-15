namespace :admin do
  def logger
    @logger ||= Logger.new(STDOUT)
  end

  task :create, [:email, :password] => :environment do |t, args|
    Admin.create!(:email => args[:email], :password => args[:password])

    logger.info "Created admin user #{args[:email]}"
  end
end