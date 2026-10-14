# Base class for controllers that do not require access
class UnauthenticatedController < ApplicationController
  default_form_builder Bh::FormBuilder
end
