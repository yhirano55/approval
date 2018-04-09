module Approval
  class Config
    attr_accessor :user_class_name, :comment_maximum,
                  :permit_to_respond_to_own_request

    def initialize
      @user_class_name = "User"
      @comment_maximum = 2000
      @permit_to_respond_to_own_request = false
    end

    def permit_to_respond_to_own_request?
      !!permit_to_respond_to_own_request
    end
  end
end
