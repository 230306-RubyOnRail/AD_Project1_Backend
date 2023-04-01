# frozen_string_literal: true

module Completable

  def completed?
    raise "Must be implemented in subclass"
  end
end
