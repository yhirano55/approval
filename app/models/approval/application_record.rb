# frozen_string_literal: true

module Approval
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
