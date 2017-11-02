module TasklistABTestable
  TASKLIST_DIMENSION = 66

  TASKLIST_PRIMARY_PAGES = %w(
    /apply-first-provisional-driving-licence
    /book-driving-test
    /book-theory-test
    /cancel-driving-test
    /cancel-theory-test
    /change-driving-test
    /change-theory-test
    /check-driving-test
    /check-theory-test
    /driving-lessons-learning-to-drive/
    /driving-test/what-to-take
    /find-driving-schools-and-lessons
    /government/publications/car-show-me-tell-me-vehicle-safety-questions
    /guidance/the-highway-code
    /legal-obligations-drivers-riders
    /pass-plus
    /take-practice-theory-test
    /theory-test/revision-and-practice
    /theory-test/what-to-take
    /vehicles-can-drive
  ).freeze

  TASKLIST_SECONDARY_PAGES = %w(
    /apply-for-your-full-driving-licence
    /automatic-driving-licence-to-manual
    /complain-about-a-driving-instructor
    /driving-eyesight-rules
    /driving-licence-fees
    /driving-test-cost
    /dvlaforms
    /find-theory-test-pass-number
    /government/publications/application-for-refunding-out-of-pocket-expenses
    /government/publications/drivers-record-for-learner-drivers
    /government/publications/driving-instructor-grades-explained
    /government/publications/know-your-traffic-signs
    /government/publications/l-plate-size-rules
    /guidance/rules-for-observing-driving-tests
    /report-an-illegal-driving-instructor
    /report-driving-medical-condition
    /report-driving-test-impersonation
    /seat-belts-law
    /speed-limits
    /track-your-driving-licence-application
    /vehicle-insurance
    /view-driving-licence
  ).freeze

  def self.included(base)
    base.helper_method :tasklist_variant, :tasklist_ab_test_applies?, :should_show_tasklist_sidebar?
    base.after_filter :set_tasklist_response_header
  end

  def tasklist_ab_test
    @tasklist_ab_test ||=
      GovukAbTesting::AbTest.new(
        "TaskListSidebar",
        dimension: TASKLIST_DIMENSION
      )
  end

  def tasklist_ab_test_applies?
    page_is_included_in_test?
  end

  def should_show_tasklist_sidebar?
    tasklist_ab_test_applies? && tasklist_variant.variant_b?
  end

  def tasklist_variant
    @tasklist_variant ||=
      tasklist_ab_test.requested_variant(request.headers)
  end

  def set_tasklist_response_header
    tasklist_variant.configure_response(response) if tasklist_ab_test_applies?
  end

  def page_is_included_in_test?
    TASKLIST_PRIMARY_PAGES.include?(request.path) ||
      TASKLIST_SECONDARY_PAGES.include?(request.path)
  end
end
