module Manageable
  extend ActiveSupport::Concern

  included do
    attr_accessor :managing
    attr_protected :managing
  end
end