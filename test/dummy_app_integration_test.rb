require 'test_helper'
require 'action_controller'
require 'coffee-rails'
require 'sass'

class DummyAppIntegrationTest < ActionController::TestCase
  tests DummyController

  # The dummy app has a custom route and controller action that renders the
  # compiled html import as a json response. We test against that here.
  test "the test files should get compiled and concatenated" do
    get :assets
    assert_equal @response.body, <<-EOS.strip_heredoc
      <script>(function() {
        var hello;
        hello = "world";
      }).call(this);
      </script>
      <p>Test CoffeeScript</p>
      <link rel="stylesheet" href="/assets/compile_scss/test.scss">
      <p>Test scss</p>
      <link rel="stylesheet" href="//fonts.googleapis.com/css?family=RobotoDraft:regular,bold,italic,thin,light,bolditalic,black,medium&lang=en">
      <p>Test external css</p>
      <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
      <p>Test external js</p>
      <p>Test simple import</p>
      <link rel="stylesheet" href="/assets/simple_css/test.css">
      <p>Test css</p>
      <script>var hello = "world";
      </script>
      <p>Test js</p>
      <polymer-element name="test" attributes="hidden src">
        <template>
          <link rel="stylesheet" href="/assets/template/test.css">
          <core-icon src="{{ iconSrc }}"></core-icon>
          <p hidden?="{{ hidden }}">Test template</p>
        </template>
      </polymer-element>
    EOS
  end
end
