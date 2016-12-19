class CompletedTransactionController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable

  before_filter :set_publication

  # These 2 legacy completed transactions are linked to from multiple
  # transactions. The user satisfaction survey should not be shown for these as
  # it would generate noisy data for the linked organisation.
  LEGACY_SLUGS = [
    "done/transaction-finished",
    "done/driving-transaction-finished"
  ].freeze

  def show
  end

private

  helper_method :show_survey?

  def show_survey?
    LEGACY_SLUGS.exclude?(params[:slug])
  end
end
