require 'test_helper'

class HomepageControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "loading the homepage" do
    setup do
      content_store_has_item("/", schema: 'special_route')
    end

    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    %w(A B).each do |test_variant|
      should "RelatedLinksABTest3 works correctly for each variant (variant: #{test_variant})" do
        with_variant RelatedLinksABTest3: test_variant do
          get :index

          ab_test = @controller.send(:related_links_test)
          requested = ab_test.requested_variant(request.headers)
          assert requested.variant?(test_variant)
        end
      end
    end
  end
end
