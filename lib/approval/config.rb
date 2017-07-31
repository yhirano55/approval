module Approval
  class Config
    attr_accessor(
      :comment_maximum,
      :user_class_name,
      :permit_to_respond_to_own_request,
    )

    def initialize
      @comment_maximum = 2000
      @user_class_name = "User"
      @permit_to_respond_to_own_request = false
    end

    def permit_to_respond_to_own_request?
      !!permit_to_respond_to_own_request
    end
  end
end
