require 'test_helper'

class ProtectedController < ApplicationController
  protect_from_gets
  allow_gets :only => :allowed_gets

  def not_allowed() head(200) end

  def explicitly() head(200) end
  allow_get :explicitly

  def allowed_gets() head(200) end

  def my_protected_get() head(200) end
  protected_get :my_protected_get

  # stub token and make it accessible
  def form_authenticity_token() 'token' end
end

class ProtectedControllerTest < ActionController::TestCase
  test 'should prevent get' do
    get :not_allowed
    assert_response :forbidden
  end

  test 'should allow explict get' do
    get :explicitly, nil, {:user => 42}
    assert_response :success
    assert_equal 42, session[:user]
  end

  test 'should allow_gets' do
    get :allowed_gets
    assert_response :success
  end

  test 'should protect get' do
    get :my_protected_get, nil, {:user => 42}
    assert_response :success
    assert_nil session[:user]
  end

  test 'should allow protected get with token' do
    get :my_protected_get, {@controller.request_forgery_protection_token => 'token'}, {:user => 42}
    assert_response :success
    assert_equal 42, session[:user]
  end
end