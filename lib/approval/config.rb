module Approval
  class Config
    attr_accessor(
      :comment_maximum,
      :permit_to_respond_to_own_request,
    )

    def initialize
      @comment_maximum = 2000
      @permit_to_respond_to_own_request = false
    end

    def permit_to_respond_to_own_request?
      !!permit_to_respond_to_own_request
    end
  end
end
