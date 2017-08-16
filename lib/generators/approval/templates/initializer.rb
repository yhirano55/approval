Approval.configure do |config|
  # User Class Name (e.g: User, AdminUser, Member)
  config.user_class_name = "User"

  # Maximum characters of comment for reason (default: 2000)
  config.comment_maximum = 2000

  # Permit to respond to own request? (default: false)
  config.permit_to_respond_to_own_request = false
end
